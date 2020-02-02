function search() {
	var tr = document.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
	var found = false; 

	for (var x = 0; x < tr.length; x++) {
		for (var y = 0; y < tr[x].getElementsByTagName("td").length; y++) {
			if (tr[x].getElementsByTagName("td")[y].textContent.toUpperCase().indexOf(document.getElementById("search").value.toUpperCase()) > -1) {
				found = true;
			}     
		}
		if (found) {
			tr[x].style.display = "block";
			found = false; 
			console.log("true");
		}
		else {
			tr[x].style.display = "none";
		}
	}
	
	$("#clear").click(function() {
		for (var x = 0; x < tr.length; x++) {
			for (var y = 0; y < tr[x].getElementsByTagName("td").length; y++) {
				tr[x].style.display = "block";
			}
		}      
	});
}

function sort(n) {
	var switchcount = 0;
	var switching = true;
	var dir = "asc";
	
	while (switching) {
		switching = false;
		var rows = document.getElementsByTagName("table")[0].rows;
		
		for (var i = 1; i < rows.length - 1; i++) {
			var shouldSwitch = false;
			var x = rows[i].getElementsByTagName("td")[n];
			var y = rows[i + 1].getElementsByTagName("td")[n];
			  
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
			rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
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
			document.getElementsByClassName("fas")[i].style.color = "#FFF";
		}
		else {
			document.getElementsByClassName("fas")[n].style.color = "#313131";
		}
	}
}