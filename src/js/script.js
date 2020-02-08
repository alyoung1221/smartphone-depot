window.addEventListener("scroll", stickyHeader);

function stickyHeader() {
	if (document.body.scrollTop > 25 || document.documentElement.scrollTop > 25) {
		$("header").attr("id", "sticky"); 
		
		if ($("#search").val()) {
			$("#clear").css("color", "transparent");
		}
	} 
	else {	
		$("header").attr("id", "");
		
		if ($("#search").val()) {
			$("#clear").css("color", "#808080");	
		}			
	}
}
$("#search").keyup(function() {
	$("#clear").css("color", "#808080");
});
function search() {
	var tr = document.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
	var td; 
	var found = false; 
	
	for (var x = 0; x < tr.length; x++) {
		for (var y = 0; y < tr[x].getElementsByTagName("td").length; y++) {
			td = tr[x].getElementsByTagName("td")[y].innerContent || tr[x].getElementsByTagName("td")[y].textContent;
 			
			if (td.startsWith("$")) {
				td = td.substring(1);
			}
			if (!(isNaN($("#search").val()))) {
				if (td === $("#search").val()) {
					found = true;
				}
			}
			else {
				if (tr[x].getElementsByTagName("td")[y].textContent.toUpperCase().indexOf(document.getElementById("search").value.toUpperCase()) > -1) {
					found = true;
				}     
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
	
	if ($("#search").val() === "") {
		displayTable(tr);
		$("#clear").css("color", "transparent");
	}
	$("#clear").click(function() {
		displayTable(tr);   
		$("#clear").css("color", "transparent");		
	});
}

function displayTable(tr) {
	for (var x = 0; x < tr.length; x++) {
		for (var y = 0; y < tr[x].getElementsByTagName("td").length; y++) {
			tr[x].style.display = "block";
		}
	} 
}

function filterPrice() {
	var tr = document.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
	
	for (var i = 0; i < tr.length; i++) {
		if (parseInt(tr[i].getElementsByTagName("td")[1].innerHTML.substring(1)) <= parseInt($("#range").val())) {
			tr[i].style.display = "block";
		}
		else {
			tr[i].style.display = "none";
		}
	}
}

function sort(n) {
	var switchcount = 0;
	var switching = true;
	var dir = "asc";
	
	while (switching) {
		switching = false;
		var tr = document.getElementsByTagName("table")[0].rows;
		
		for (var i = 1; i < tr.length - 1; i++) {
			var shouldSwitch = false;
			var x = tr[i].getElementsByTagName("td")[n];
			var y = tr[i + 1].getElementsByTagName("td")[n];
			  
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
		document.getElementsByClassName("fas")[n].className = "fas fa-arrow-up";
	}
	else if (dir == "desc") {
		document.getElementsByClassName("fas")[n].className = "fas fa-arrow-down";
	}
	
	for (var i = 0; i < document.getElementsByClassName("fas").length; i++) {
		if (i != n) {
			document.getElementsByClassName("fas")[i].className = "fas fa-sort";
		}
	}
}