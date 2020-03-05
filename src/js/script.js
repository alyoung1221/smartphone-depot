$(window).click(removeFocus);
$(window).scroll(stickyHeader);
$(window).resize(function(e) {
	if ($(window).width() >= 1000 && $(".menu").eq(0).hasClass("opennav")) {
		closeNav();
	}
});

$("#open").focus(openNav);
$("#close").focus(closeNav);
$("#date").html(new Date().getFullYear()); 
$(".fa-sort").each(function(index) {
	$(this).click(function() {sort(index);});
});
$(".quantity button").each(function(e) {
	$(this).click(function(e) {setQuantity(e);});
});

function removeFocus() {
	var active = document.activeElement.tagName; 

	if (active != "INPUT" && active != "TEXTAREA" && active != "SELECT" && document.activeElement.className.indexOf("expand") == -1) {
		document.activeElement.blur();
	}
}

function stickyHeader() {	
	if (document.body.scrollTop > 112 || document.documentElement.scrollTop > 112) {
		$("header").eq(0).attr("id", "sticky"); 
		$(".zoom img").eq(0).css("transition", "none");
	} 
	else {	
		$("header").eq(0).removeAttr("id");
		$(".zoom img").eq(0).css("transition", "opacity .5s");
	}
}
		
function openNav() {
	$(".menu").eq(0).removeClass("closenav").addClass("opennav transition");
	$(".menu-container").eq(0).attr("id", "body-overlay");
}

function closeNav() {
	$(".menu").eq(0).removeClass("opennav").addClass("closenav");
	$(".menu-container").removeAttr("id");
}

// Show Product Details
function showProduct(index) {
	var product = $(".popup-hidden").eq(index);
	
	if (product.hasClass("popup-hidden")) {
		product.removeClass("popup-hidden");
		product.addClass("popup");
		$("body").css("overflow-y", "hidden");
		$(".menubar").eq(index).addClass("hidden");
	}
	
	$(".close").eq(index).focus(function() {		
		closeProduct(product); 
	});

	$(window).click(function(event) {
		if ($(event.target).hasClass("popup")) {
			closeProduct(product);
		}
	});
}

function showProductDetails() {
	var button = document.getElementsByClassName("product-info");
	var i;

	for (i = 0; i < button.length; i++) {
		var info = this.nextSibling;
		if (info.className == "hidden") {
			info.classList.remove("hidden");
		}
		else {
			info.className = "hidden";
		}
	};
}

function setQuantity(e) {
	var quantity = $(e.target).hasClass("plus") ? e.target.previousElementSibling : e.target.nextElementSibling; 
	
	if ($(e.target).hasClass("plus")) {
		quantity.stepUp();
	}
	else {
		quantity.stepDown();
	}

	if ($("[name='size']:checked").val() && $("[name='grade']:checked").val()) {
		$(".price").html("$" + parseFloat($(".price").attr("data-price") * quantity.value).toFixed(2)); 
	}
}

function closeProduct(product) {
	$("body").css("overflow-y", "visible");
	product.removeClass("popup");
	product.addClass("popup-hidden");
	
	for (var i = 0; i < document.forms.length; i++) {
		document.forms.item(i).reset();
	};
	$(".color").html("Please Select"); 
	$(".size").html("Please Select"); 
	$(".grade").html("Please Select"); 
	$(".price").empty();
	$(".price-range").removeClass("hidden");
}	

function updatePrice(index) {
	if (window.XMLHttpRequest) {
		xmlhttp = new XMLHttpRequest();
	} 
	else {
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			$(".price").attr("data-price", this.responseText.substring(1));
			var total = (parseFloat(this.responseText.substring(1)) * $("[name='quantity']").val()).toFixed(2);
			$(".price-range").addClass("hidden");
			$(".price").html("$" + total);
		}
	};
	
	var request = "actions.php?id=" + index + "&grade=" + $("[name='grade']:checked").attr("data-grade-id") + "&size=" + $("[name='size']:checked").attr("data-size-id");
	xmlhttp.open("GET", request, true);
	xmlhttp.send(); 
}

function zoom(e){
	var zoomer = e.currentTarget;
	e.offsetX ? offsetX = e.offsetX : offsetX = e.touches[0].pageX;
	e.offsetY ? offsetY = e.offsetY : offsetX = e.touches[0].pageX;
	x = offsetX / zoomer.offsetWidth * 100;
	y = offsetY / zoomer.offsetHeight * 100;
	zoomer.style.backgroundPosition = x + '% ' + y + '%';
}

function sort(n) {
	var switchcount = 0;
	var switching = true;
	var dir = "asc";
	
	while (switching) {
		switching = false;
		var tr = document.getElementsByTagName("table")[0].rows;
		var shouldSwitch = false;
					
		for (var i = 1; i < tr.length - 1; i++) {
			var x = n === 0 ? tr[i].getElementsByTagName("th")[n] : tr[i].getElementsByTagName("td")[n - 1];
			var y = n === 0 ? tr[i + 1].getElementsByTagName("th")[n] : tr[i + 1].getElementsByTagName("td")[n - 1];
			  
			if (dir == "asc") {
				if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
					shouldSwitch = true;
					break;
				}
			} 
			else if (dir == "desc") {
				if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
					shouldSwitch = true;
					break;
				}
			}
		}

		if (shouldSwitch) {
			tr[i].parentNode.insertBefore(tr[i + 1], tr[i]);
			switching = true;
			switchcount++;
		} 
		else {
			if (switchcount == 0 && dir == "asc") {
				dir = "desc";
				switching = true;
			}
		}
	}
		
	if (dir == "asc") {
		$("th").eq(n).find("button:not([name='reset']").attr("class", "fas fa-arrow-up");
	}
	else if (dir == "desc") {
		$("th").eq(n).find("button:not([name='reset']").attr("class", "fas fa-arrow-down");
	}
	
	for (var i = 0; i < $("thead th").length; i++) {
		if (i != n) {
			$("th").eq(i).find("button:not([name='reset']").attr("class", "fas fa-sort");
		}
	}
}

function displayTable() {
	var tr = document.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

	for (var x = 0; x < tr.length; x++) {
		tr[x].style.display = "block";
	} 
}
