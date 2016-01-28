/* ****************************************************** *
 *                 --- Keycut v1.3.1 ---                  *
 * jQuery plugin for simple keyboard shortcuts            *
 * https://github.com/duncannz/keycut                     *
 *                                                        *
 * Copyright (c) Duncan de Wet, et al.                    *
 * Licensed under the terms of the MIT License.           *
 * See the LICENSE.md file in the root of the repository. *
 * ****************************************************** */

(function($){
	
	$.fn.keycut = function(){
		
		//bind to the "keydown" event on `this` (should be `document`)
		return this.keydown(function(event){
			
			var code = event.keyCode, //the JS keycode for the pressed key
			pressed_key, //will contain the actual name of the pressed key
			element; //will contain the element that the pressed key is bound to
			
			
			//work out what key it was that was pressed
			
			//letters
			if(code === 65) pressed_key = 'a';
			else if(code === 66) pressed_key = 'b';
			else if(code === 67) pressed_key = 'c';
			else if(code === 68) pressed_key = 'd';
			else if(code === 69) pressed_key = 'e';
			else if(code === 70) pressed_key = 'f';
			else if(code === 71) pressed_key = 'g';
			else if(code === 72) pressed_key = 'h';
			else if(code === 73) pressed_key = 'i';
			else if(code === 74) pressed_key = 'j';
			else if(code === 75) pressed_key = 'k';
			else if(code === 76) pressed_key = 'l';
			else if(code === 77) pressed_key = 'm';
			else if(code === 78) pressed_key = 'n';
			else if(code === 79) pressed_key = 'o';
			else if(code === 80) pressed_key = 'p';
			else if(code === 81) pressed_key = 'q';
			else if(code === 82) pressed_key = 'r';
			else if(code === 83) pressed_key = 's';
			else if(code === 84) pressed_key = 't';
			else if(code === 85) pressed_key = 'u';
			else if(code === 86) pressed_key = 'v';
			else if(code === 87) pressed_key = 'w';
			else if(code === 88) pressed_key = 'x';
			else if(code === 89) pressed_key = 'y';
			else if(code === 90) pressed_key = 'z';
			
			//number keys (normal or numpad)
			else if(code === 48 || code === 96) pressed_key = '0';
			else if(code === 49 || code === 97) pressed_key = '1';
			else if(code === 50 || code === 98) pressed_key = '2';
			else if(code === 51 || code === 99) pressed_key = '3';
			else if(code === 52 || code === 100) pressed_key = '4';
			else if(code === 53 || code === 101) pressed_key = '5';
			else if(code === 54 || code === 102) pressed_key = '6';
			else if(code === 55 || code === 103) pressed_key = '7';
			else if(code === 56 || code === 104) pressed_key = '8';
			else if(code === 57 || code === 105) pressed_key = '9';
			
			//misc. punctuation
			else if(code === 192) pressed_key = '`';
			else if(code === 189) pressed_key = '-';
			else if(code === 187) pressed_key = '=';
			else if(code === 219) pressed_key = '[';
			else if(code === 221) pressed_key = ']';
			else if(code === 220) pressed_key = '\\';
			else if(code === 186) pressed_key = ';';
			else if(code === 188) pressed_key = ',';
			else if(code === 190) pressed_key = '.';
			else if(code === 191) pressed_key = '/';
			else if(code === 222) pressed_key = '\'';
			
			//other
			else if(code === 13) pressed_key = 'enter';
			else if(code === 32) pressed_key = 'space';
			else if(code === 8) pressed_key = 'backspace';
			else if(code === 37) pressed_key = 'left';
			else if(code === 38) pressed_key = 'up';
			else if(code === 39) pressed_key = 'right';
			else if(code === 40) pressed_key = 'down';
			
			//function keys
			else if(code === 112) pressed_key = 'F1';
			else if(code === 113) pressed_key = 'F2';
			else if(code === 114) pressed_key = 'F3';
			else if(code === 115) pressed_key = 'F4';
			else if(code === 116) pressed_key = 'F5';
			else if(code === 117) pressed_key = 'F6';
			else if(code === 118) pressed_key = 'F7';
			else if(code === 119) pressed_key = 'F8';
			else if(code === 120) pressed_key = 'F9';
			else if(code === 121) pressed_key = 'F10';
			else if(code === 122) pressed_key = 'F11';
			else if(code === 123) pressed_key = 'F12';
			
			//if the key was ESC, not only set the key to 'esc', but also blur any textboxes on the page
			//this means that if a text box is focused, you can press ESC and then a shortcut,
			//rather than having to reach for the mouse to "click off" the text box
			else if(code === 27)
			{
				pressed_key = 'esc';
				$("input:focus, textarea:focus").blur();
			}
			
			
			//get the element bound to the pressed key (there *should* only be one)
			element = $("[data-key='" + pressed_key + "']").first();
			
			//if there were no elements matched, abort
			if( element.length === 0 ) return true;
			
			
			//if the CTRL or ALT or META key is currently pressed then don't do anything - they might be trying to use a keyboard shortcut
			if( event.ctrlKey || event.altKey || event.metaKey ) return true;
			
			//if they are busy typing in a text box, and the key wasn't a function key, make sure shortcuts don't get followed
			if( $("input:focus, textarea:focus").length > 0 && pressed_key[0] !== "F" ) return true;
			
			
			//by now, we have done enough checks, so assume go-ahead if return true hasn't happened yet
			
			//focus the element (ie text box) and click on the element (ie link)
			//use native DOM instead of jQuery because jQuery's .click() doesn't seem to run onclick actions
			element[0].focus();
			$(element[0]).trigger('click');
			
			//stop any browser default action on the pressed key (ie. F5 - refresh)
			//since it can be annoying for users having their browsers' keys overriden, it is reccomended to avoid keys like F5
			return false;
			
		});//on keydown
		
	};//fn.keycut
	
})(jQuery);
