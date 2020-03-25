(function ($) {
  $.fn.niceNumber = function(options) {
    var settings = $.extend({
      autoSize: true,
      autoSizeBuffer: 1,
      buttonDecrement: '-',
      buttonIncrement: "+",
      buttonPosition: 'around',
    }, options);

    return this.each(function(){
      var currentInput = this,
          $currentInput = $(currentInput),
          attrMax = null,
          attrMin = null,
		  step = parseInt(this.getAttribute("step"));

      // Skip already initialized input
      if ($currentInput.attr('data-nice-number-initialized')) return

      // Handle max and min values
      if (
        typeof $currentInput.attr('max') !== typeof undefined
        && $currentInput.attr('max') !== false
      ) {
        attrMax = parseFloat($currentInput.attr('max'));
      }

      if (
        typeof $currentInput.attr('min') !== typeof undefined
        && $currentInput.attr('min') !== false
      ) {
        attrMin = parseFloat($currentInput.attr('min'));
      }

      // Fix issue with initial value being < min
      if (
        attrMin
        && !currentInput.value
      ) {
        $currentInput.val(attrMin);
      }

      // Generate container
      var $inputContainer = $('<div/>',{
          class: 'nice-number'
        })
        .insertAfter(currentInput);

      // Generate interval (object so it is passed by reference)
      var interval = {};

      // Generate buttons
      var $minusButton = $('<button/>')
        .attr({
			'type' : 'button', 
			'name' : 'decrement'
		})
        .html(settings.buttonDecrement)
        .on('mousedown mouseup mouseleave keypress', function(event){
          changeInterval(event.type, interval, function(){
            if (
              attrMin == null
              || attrMin < parseFloat(currentInput.value)
            ) {
              currentInput.value =  parseInt(currentInput.value) - step;
            }
          });

          // Trigger the input event here to avoid event spam
          if (
            event.type == 'mouseup'
            || event.type == 'mouseleave'
          ) {
            $currentInput.trigger('input');
          }
		   if (
            event.type == 'keypress'
          ) {
            $currentInput.trigger('input');
          }
        });
      var $plusButton = $('<button/>')
        .attr({
			'type' : 'button', 
			'name' : 'increment'
		})
        .html(settings.buttonIncrement)
        .on('mousedown mouseup mouseleave keypress', function(event){
          changeInterval(event.type, interval, function(){
            if (
              attrMax == null
              || attrMax > parseFloat(currentInput.value)
            ) {
              currentInput.value =  parseInt(currentInput.value) + step;
            }
          });

          // Trigger the input event here to avoid event spam
          if (
            event.type == 'mouseup'
            || event.type == 'mouseleave'
          ) {
            $currentInput.trigger('input');
          }
		   if (
            event.type == 'keypress'
          ) {
            $currentInput.trigger('input');
          }
        });
		
		$(window).keyup(function(e) {
			var code = (e.keyCode ? e.keyCode : e.which);
				
			if (code === 13) {
				if ($(e.target).attr("name") === "decrement") {
					if (attrMin == null || attrMin < parseFloat(currentInput.value)) {
						currentInput.value =  parseInt(currentInput.value) - step;
					}
				}
				else if ($(e.target).attr("name") === "increment") {
					if (attrMax == null || attrMax > parseFloat(currentInput.value)) {
						currentInput.value =  parseInt(currentInput.value) + step;
					}
				}
			}
		});
      // Remember that we have initialized this input
      $currentInput.attr('data-nice-number-initialized', true);

      // Append elements
      switch (settings.buttonPosition) {
        case 'left':
          $minusButton.appendTo($inputContainer);
          $plusButton.appendTo($inputContainer);
          $currentInput.appendTo($inputContainer);
          break;
        case 'right':
          $currentInput.appendTo($inputContainer);
          $minusButton.appendTo($inputContainer);
          $plusButton.appendTo($inputContainer);
          break;
        case 'around':
        default:
          $minusButton.appendTo($inputContainer);
          $currentInput.appendTo($inputContainer);
          $plusButton.appendTo($inputContainer);
          break;
      }

      // Nicely size input
      if (settings.autoSize) {
        $currentInput.width(
          $currentInput.val().length+settings.autoSizeBuffer+"ch"
        );
        $currentInput.on('keyup input',function(){
          $currentInput.animate({
            'width': $currentInput.val().length+settings.autoSizeBuffer+"ch"
          }, 200);
        });
      }
    });
  };

  function changeInterval(eventType, interval, callback) {
    if (eventType == "mousedown") {
      interval.timeout = setTimeout(function(){
        interval.actualInterval = setInterval(function(){
          callback();
        }, 100);
      }, 200);
      callback();
    } else {
      if (interval.timeout) {
        clearTimeout(interval.timeout);
      }
      if (interval.actualInterval) {
        clearInterval(interval.actualInterval);
      }
    }
  }
}(jQuery));
