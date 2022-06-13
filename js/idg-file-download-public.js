(function( $ ) {
	'use strict';

	/**
	 * All of the code for your public-facing JavaScript source
	 * should reside in this file.
	 *
	 * Note: It has been assumed you will write jQuery code here, so the
	 * $ function reference has been prepared for usage within the scope
	 * of this function.
	 *
	 * This enables you to define handlers, for when the DOM is ready:
	 *
	 * $(function() {
	 *
	 * });
	 *
	 * When the window is loaded:
	 *
	 * $( window ).load(function() {
	 *
	 * });
	 *
	 * ...and/or other possibilities.
	 *
	 * Ideally, it is not considered best practise to attach more than a
	 * single DOM-ready or window-load handler for a particular page.
	 * Although scripts in the WordPress core, Plugins and Themes may be
	 */
	$(document).ready( function() {
		
		// create a function to actually fire the search
		function bfdDoSearch(t) {
			
	        // do the ajax request for search
			    $.ajax({
				    
				    type: 'post',
				    url: idg_js.ajaxurl, // the localized name of the file
				    data: {
					    action: 'idg_ajax_download_search', // the wp_ajax_ hook name
					      search: t
				    },
				
				    // what happens on success
				    success: function( result ) {

					    // if the ajax call returns no results
					    if( result === 'error' ) {
						    
						    // set the html of the element with the class to no results
						    $( '.bfd-ajax-results' ).html( 'No results' );
					    
					    // we have results to display
					    } else {
						    
						    // populate the results markup in the element with the class of bfd-ajax-results
						    $( '.bfd-ajax-results' ).html( result );
						
					    }

				    }
				
			    });
	        
	    }
	    
	    var thread = null;
	    
	    // when the keyboard press is released in the input with the class bfd-search-input-box
	    $('.bfd-search-input-box').keyup(function() {			
			// clear our timeout variable - to start the timer again
			clearTimeout(thread);
			  
			// set a variable to reference our current element ajax-search
			var $this = $(this);

			  //clear result panel if the value is blank
	        if (!this.value.trim()) {

	            $('.bfd-ajax-results').html('');
	            return;

	        } else {
	        	
	        	// set a timeout to wait for a second before running the bfdDoSearch function
				thread = setTimeout(
					function() {
					  	bfdDoSearch($this.val())
					},
					 1000
				  );
	        }
			  
	    });
		
	});
})( jQuery );
