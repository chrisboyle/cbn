function selectTextField(fieldid, range) {
	var field = document.getElementById(fieldid);
	var start = range[0], end = range[1];
	if( field.createTextRange ) {
		var selRange = field.createTextRange();
		selRange.collapse(true);
		selRange.moveStart('character', start);
		selRange.moveEnd('character', end-start);
		selRange.select();
	} else if( field.setSelectionRange ) {
		field.setSelectionRange(start, end);
	} else if( field.selectionStart ) {
		field.selectionStart = start;
		field.selectionEnd = end;
	}
	field.focus();
}
