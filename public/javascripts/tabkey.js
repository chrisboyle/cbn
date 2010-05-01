function insertAtCursor(field, val) {
	if (document.selection) {
		field.focus();
		var sel = document.selection.createRange();
		var oldLength = sel.text.length;
		sel.text = val;
		if (val.length == 0) {
			sel.moveStart('character', 0);
			sel.moveEnd('character', 0);
		} else {
			sel.moveStart('character', -val.length + oldLength);
		}
		sel.select();
	} else if (field.selectionStart || field.selectionStart == '0') {
		var startPos = field.selectionStart;
		var endPos = field.selectionEnd;
		field.value = field.value.substring(0, startPos) + val + field.value.substring(endPos, field.value.length);
		field.selectionStart = startPos + val.length;
		field.selectionEnd = startPos + val.length;
	} else {
		field.value += val;
	}
}

function checkTab(f,e)
{
	if (e.keyCode != 9 || e.shiftKey) return true;
	insertAtCursor(f, "\t");
	if (e.preventDefault)
		e.preventDefault();
	return false;
}
