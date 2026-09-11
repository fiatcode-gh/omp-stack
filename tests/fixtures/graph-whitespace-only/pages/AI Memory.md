   	   
	
## [[Other]]
- WHITESPACE_MARK whitespace-only fixture: the only text above the first heading is blank, spanning two lines (spaces-and-a-tab, then a bare tab), and the heading itself never matches any test project — a correct injector emits NOTHING for this hub, even though the raw slice is a non-empty string joined by an interior newline that a space/tab-only test would miss.
