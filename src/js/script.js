$(window).click(removeFocus);
$(window).click(function(e) {		
	if ($(e.target).attr("id") === "body-overlay") {
		closeNav();
	}
});
$(window).scroll(stickyHeader);
$(window).resize(function() {
	if ($(window).width() >= 1000 && $(".menu").eq(0).hasClass("opennav")) {
		closeNav();
	}
});

$("#open").focus(openNav);
$("#close").click(closeNav);
$("#date").html(new Date().getFullYear()); 
$(".fa-sort").each(function(index) {
	$(this).click(function() {sort(index);});
});
$(".zoom").each(function() {
	$(this).mousemove(function(e) {
		var zoomer = e.currentTarget;
		e.offsetX ? offsetX = e.offsetX : offsetX = e.touches[0].pageX;
		e.offsetY ? offsetY = e.offsetY : offsetX = e.touches[0].pageX;
		x = offsetX / zoomer.offsetWidth * 100;
		y = offsetY / zoomer.offsetHeight * 100;
		zoomer.style.backgroundPosition = x + '% ' + y + '%';
	});
}); 
$("[name='color']").click(function() {
	$(".color").html($("[name='color']:checked").val()); 
});
$("[name='size']").click(function() {
	$(".size").html($("[name='size']:checked").val()); 
			
	if ($("[name='grade']:checked").val() && $("[name='size']:checked").val()) {
		var id = $(".product").eq(0).attr("data-id");
		updatePrice(id);
	}
});

$("[name='grade']").click(function() {
	$(".grade").html($("[name='grade']:checked").val()); 
								
	if ($("[name='grade']:checked").val() && $("[name='size']:checked").val()) {
		var id = $(".product").eq(0).attr("data-id");
		updatePrice(id);
	}
});
		
function removeFocus() {
	var active = document.activeElement.tagName; 

	if (active != "INPUT" && active != "TEXTAREA" && active != "SELECT" && document.activeElement.className.indexOf("expand") == -1 && document.activeElement.getAttribute("contentEditable") == "true") {
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
	$("body").css("overflow-y", "hidden");
}
$("[name='toggle']").each(function(index) {
	$(this).click(function() {
		var content = (index === 0) ? $(".dropdown") : $(".subdropdown");
		content.toggleClass("visible");
		$(".submenu-item:last-of-type").focusout(function() {
			$(".menu-item:first-of-type ul").removeClass("visible");
		}); 
	});
});
function closeNav() {
	$(".menu").eq(0).removeClass("opennav").addClass("closenav");
	$(".menu-container").removeAttr("id");
	$("body").css("overflow-y", "visible");
	$("h1").eq(0).focus();
	$(".dropdown").removeClass("visible");
	$(".subdropdown").removeClass("visible");
}

$(".last").eq(0).focusout(function() {
	closeNav();
});
$(".menu").focusin(function() {
	$(window).keyup(function(e) {
		var code = (e.keyCode ? e.keyCode : e.which);
		if (code == 27) {
			closeNav();
		}
	});
}); 

function setQuantity() {	
	if ($("[name='size']:checked").val() && $("[name='grade']:checked").val() && $("#price").attr("data-price")) {
		$("#total span").html(parseFloat($("#price").attr("data-price") * $("#quantity").val()).toFixed(2)); 
	}
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
			$(".price-range").addClass("hidden");
			var total = (parseFloat(this.responseText.substring(1)) * $("[name='quantity']").val()).toFixed(2);
			
			$("#price").attr("data-price", this.responseText.substring(1));
			$("#price").html("$" + parseFloat(this.responseText.substring(1)) + "<br><br>");
			$("#total").html("<br><br>Total: $<span>" + total + "</span>");
		}
	};
	
	var request = "/components/actions.php?id=" + index + "&grade=" + $("[name='grade']:checked").attr("data-grade-id") + "&size=" + $("[name='size']:checked").attr("data-size-id");
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
		
function search() {
	var tr = document.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
	var td; 
	var found = false; 
	
	for (var x = 0; x < tr.length; x++) {
		for (var y = 0; y < tr[x].getElementsByTagName("td").length; y++) {
			td = tr[x].getElementsByTagName("td")[y].innerContent || tr[x].getElementsByTagName("td")[y].textContent;

			if (td.toUpperCase().indexOf(document.getElementById("isearch").value.toUpperCase()) > -1) {
				found = true;
			} 
		}

		if (found) {
			tr[x].style.display = "block";
			found = false; 
		}
		else {
			tr[x].style.display = "none";
		}
	}
	
	if ($("#isearch").val() === "") {
		displayTable();
	}
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
			var x = n === 0 ? tr[i].getElementsByTagName("th")[n].innerText || tr[i].getElementsByTagName("th")[n].textContent
			: tr[i].getElementsByTagName("td")[n - 1].innerText || tr[i].getElementsByTagName("td")[n - 1].textContent;
			
			var y = n === 0 ? tr[i + 1].getElementsByTagName("th")[n].innerText || tr[i + 1].getElementsByTagName("th")[n].textContent
			: tr[i + 1].getElementsByTagName("td")[n - 1].innerText || tr[i + 1].getElementsByTagName("td")[n - 1].textContent;
			
			if (dir == "asc") {
				if (!isNaN(parseInt(x)) && !isNaN(parseInt(y))) {
					if (parseInt(x) > parseInt(y)) {
						shouldSwitch = true;
						break;
					}
				}
				else {
					if (x.toLowerCase() > y.toLowerCase()) {
						shouldSwitch = true;
						break;
					}
				}
			} 
			else if (dir == "desc") {
				if (!isNaN(parseInt(x)) && !isNaN(parseInt(y))) {
					if (parseInt(x) < parseInt(y)) {
						shouldSwitch = true;
						break;
					}
				}
				else {
					if (x.toLowerCase() < y.toLowerCase()) {
						shouldSwitch = true;
						break;
					}
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
