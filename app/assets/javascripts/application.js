// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$( document ).ready ( function () {
	var $zombie_message = $( '#zombie_message' );
	var $commit = $( '#commit' );
	var $char_counter = $( '#char-counter' );

	var charsLeft =  140 - $zombie_message.val ().length * 1;
	if ( charsLeft <= 0 ) {
		$char_counter.addClass ( 'too-many' );
	}

	if ( charsLeft < 0 ) {
		$commit.attr ( 'disabled', true );
	}

	$zombie_message.on ( 'keyup', function () {
		charsLeft =  140 - $zombie_message.val ().length * 1;

		if ( charsLeft <= 0 ) {
			$char_counter.html ( charsLeft ).addClass ( 'too-many' );
		} else {
			$char_counter.html ( charsLeft ).removeClass ( 'too-many' );
		}

		if ( charsLeft < 0 ) {
			$commit.attr ( 'disabled', true );
		} else {
			$commit.attr ( 'disabled', false );
		}
	} );
} );