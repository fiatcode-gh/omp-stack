from pathlib import Path
import re, sys, yaml

ROOT = Path(__file__).resolve().parents[1]
errors=[]

def err(msg): errors.append(msg)

def frontmatter(p):
    text=p.read_text()
    if not text.startswith('---\n'):
        err(f'{p.relative_to(ROOT)}: missing frontmatter'); return {}, text
    try:
        _, raw, body = text.split('---', 2)
        data=yaml.safe_load(raw) or {}
        if not isinstance(data, dict): raise TypeError('frontmatter is not mapping')
        return data, body
    except Exception as e:
        err(f'{p.relative_to(ROOT)}: invalid frontmatter: {e}'); return {}, text

skills=list((ROOT/'agent/skills').glob('*/SKILL.md'))
agents=list((ROOT/'agent/agents').glob('*.md'))
rules=list((ROOT/'agent/rules').glob('*.md'))

if len(skills)!=14: err(f'expected 14 skills, got {len(skills)}')
if len(agents)!=6: err(f'expected 6 agents, got {len(agents)}')
if len(rules)!=2: err(f'expected 2 rules, got {len(rules)}')

names=set()
for p in skills:
    fm,body=frontmatter(p)
    name=fm.get('name'); desc=fm.get('description')
    if not name or not desc: err(f'{p}: skill needs name+description')
    if name in names: err(f'duplicate skill name {name}')
    names.add(name)
    if 'flow-using-skills' in body: err(f'{p}: legacy bootstrap reference')
    if re.search(r'pass (?:the )?model explicitly|explicit model per|model: openai-codex/', body, re.I): err(f'{p}: concrete/per-dispatch model routing leaked into skill')

expected={
'flow-design','flow-execution','flow-tdd','flow-debugging','flow-review','flow-integrating','flow-ldd','flow-external-session','forgejo','ui-design','blog-post','weft-worklog','weft-memory','weft-maintenance'}
if names!=expected: err(f'skill set mismatch: {sorted(names^expected)}')

agent_names=set()
allowed_roles={'@task','@review_aux'}
for p in agents:
    fm,body=frontmatter(p); name=fm.get('name'); desc=fm.get('description')
    if not name or not desc: err(f'{p}: agent needs name+description')
    agent_names.add(name)
    model=fm.get('model')
    if model and model not in allowed_roles: err(f'{p}: unexpected agent role {model}')
    if re.search(r'openai-codex/|gpt-5', p.read_text()): err(f'{p}: concrete model leaked into agent')

for p in rules:
    fm,body=frontmatter(p)
    if fm.get('alwaysApply') is not True: err(f'{p}: rule must alwaysApply')
    if not fm.get('name') or not fm.get('description'): err(f'{p}: rule needs name+description')

# Removed old workflow assumptions must not survive outside migration docs.
check_paths=[ROOT/'agent']
for base in check_paths:
    for p in base.rglob('*'):
        if not p.is_file() or p.suffix not in {'.md','.ts'}: continue
        text=p.read_text()
        for bad in ['never spawn an agent for work that writes', 'Never pick silently: ask the user which one', 'every new function has a test']:
            if bad.lower() in text.lower(): err(f'{p.relative_to(ROOT)}: legacy rule survived: {bad}')

# LDD boundary is intentional and explicit.
ldd=(ROOT/'agent/skills/flow-ldd/SKILL.md').read_text().lower()
if 'architect **never writes production code**' not in ldd: err('LDD strict non-coding architect rule missing')
if '.flow/ldd' not in ldd: err('LDD .flow namespace missing')

# Nested delegation and live-clarification contract.
impl_path=ROOT/'agent/agents/flow-implementer.md'
impl_fm,impl_body=frontmatter(impl_path)
spawns=impl_fm.get('spawns')
if spawns != ['scout','sonic']: err(f'flow-implementer spawns must be exactly scout+sonic, got {spawns!r}')
impl_lower=impl_body.lower()
for required in ['mechanical leaf work','hub','main','nested children share your current workspace',"child's report is a claim"]:
    if required not in impl_lower: err(f'flow-implementer missing nested delegation/clarification invariant: {required}')

execution=(ROOT/'agent/skills/flow-execution/SKILL.md').read_text().lower()
for required in [
    'route by work type', 'preserve the unit owner', 'clarify live',
    'never broadly tell a writer', 'route corrections cheaply',
    'delegation never transfers verification responsibility',
    'a complete review round is not automatic',
]:
    if required not in execution: err(f'flow-execution missing execution-policy invariant: {required}')

for required in [
    'current flow/omp stack owns **execution mechanics**', 'flow-execution',
    'bounded parallel read-only `scout`', 'normally non-isolated',
    'correct efficiently', 'worker self-verification is required',
]:
    if required not in ldd: err(f'flow-ldd missing execution-policy invariant: {required}')

evidence=(ROOT/'agent/rules/flow-evidence.md').read_text().lower()
for required in [
    'writers verify their own work', 'delegation never transfers verification responsibility',
    'leaf worker proves its leaf', 'do not rerun the same expensive full suite',
]:
    if required not in evidence: err(f'flow-evidence invariant missing: {required}')

safety=(ROOT/'agent/rules/flow-safety.md').read_text().lower()
for required in ['sole/sequential writer', 'independent concurrent writers', 'completed isolated task workspaces']:
    if required not in safety: err(f'flow-safety workspace-lifecycle invariant missing: {required}')

tdd=(ROOT/'agent/skills/flow-tdd/SKILL.md').read_text().lower()
for required in ['ownership and workspace safety', 'higher-layer verification', 'unit owner']:
    if required not in tdd: err(f'flow-tdd layered-proof invariant missing: {required}')

review=(ROOT/'agent/skills/flow-review/SKILL.md').read_text().lower()
if 'do **not** automatically repeat every original lens' not in review:
    err('flow-review affected-lens rerun invariant missing')

integrating=(ROOT/'agent/skills/flow-integrating/SKILL.md').read_text().lower()
if 'do not rerun an expensive final command merely because control moved into this skill' not in integrating:
    err('flow-integrating fresh-evidence reuse invariant missing')


# Relative skill asset references must resolve from each skill directory.
asset_re = re.compile(r'`((?:references|scripts)/[^`]+)`')
for p in skills:
    text=p.read_text()
    for rel in asset_re.findall(text):
        # Strip punctuation accidentally captured inside code spans only when it is obvious.
        target=p.parent/rel
        if not target.exists(): err(f'{p.relative_to(ROOT)}: missing referenced asset {rel}')

# Every role used by custom agents must exist in the recommended modelRoles map.
cfg=yaml.safe_load((ROOT/'config.recommended.yml').read_text())
roles=set((cfg.get('modelRoles') or {}).keys())
for p in agents:
    fm,_=frontmatter(p)
    model=fm.get('model')
    if isinstance(model,str) and model.startswith('@') and model[1:] not in roles:
        err(f'{p.relative_to(ROOT)}: role {model} missing from config.recommended.yml')

# The principle-preservation ledger must account for every old skill from ai-stack.
old={
'blog-post','find-todo','flow-auditing-codebases','flow-brainstorming','flow-debugging',
'flow-executing-plans','flow-finishing','flow-handover','flow-ldd','flow-mailbox',
'flow-receiving-pr-reviews','flow-reviewing-prs','flow-tdd','flow-using-skills',
'flow-verification','flow-workspace','flow-writing-plans','forgejo','frontend-design',
'journal-update','memory-gc','memory-update','recall-memory','retrofit'}
ledger=(ROOT/'docs/PRINCIPLES.md').read_text()
for name in sorted(old):
    if f'`{name}`' not in ledger: err(f'docs/PRINCIPLES.md: old skill not accounted for: {name}')

if errors:
    print('\n'.join('FAIL: '+e for e in errors)); sys.exit(1)
print(f'ok: {len(skills)} skills, {len(agents)} agents, {len(rules)} rules')
