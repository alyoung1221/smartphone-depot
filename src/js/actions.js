function remove() {
	if ($("[name='phones']:checked").length == 0) {
		alert("Please select a phone to remove.");
	}
	else if ($("[name='phones']:checked").length == 1) {
		confirm("Are you sure you want to remove this phone?");
	}
	else {
		confirm("Are you sure you want to remove these phones?");
	}
}
		
function reset(table) {
	table.search('').columns().search('').draw();
	$("[name='reset']").blur();
	$('select').prop('selectedIndex', 0);
}
	
$("select").change(function() {
	if ($(this).val()) {
		$(this).blur();
	}
});

function selectAll(el) {;
	$("[name='phones[]']").each(function() {
		$(this).attr("checked", true);
	});
	$(".editable").addClass("hidden");
	$(".update").removeClass("hide");
	el.html("Unselect All");
	el.val("unselectAll");
}

function unselectAll(el) {
	$("[name='phones[]']").each(function() {
		$(this).attr("checked", false);
	});
	$(".editable").removeClass("hidden");
	$(".update").addClass("hide");	
	el.html("Select All");
	el.val("selectAll");
}

function update() {
	if ($("[name='phones[]']:checked").length == 0) {
		alert("Please select a phone to update.");
	}
	else {
		alert(); 
	}
}

function edit() {
	if ($("[name='phones[]']:checked").length == 0) {
		alert("Please select a phone to edit.");
	}
	else {
		$("#managePhones").attr("action", "edit-product");
		$("#managePhones").submit();
	}
}

$("[name='quantity']").niceNumber({
	autoSize: false,
	buttonDecrement: '-',
	buttonIncrement: "+",
	buttonPosition: 'around'
})

function capitalize(str) {
	return str.replace(/\w\S*/g, function(txt){
		return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
	});
}