// JavaScript Document
/*
this file will be lick to the event.html pages
This file of Javascript will have 5 main event click button to do things
first click event is open the new window for user sign up
second click event is close window 
third click event is play game that user want to get coupons to eat free
fours click event is open the new window to read rule
five click event is for user login and greating sentence to them
*/
		
		
		
		var child;
		// fuction start that register and call others function to do event
		function start()
		{
			document.getElementById('openW').addEventListener("click",open_window,false);
			document.getElementById('closeW').addEventListener("click",close_window,false);
			document.getElementById("playsubmit").addEventListener("click",playgame,false);
			document.getElementById('rules').addEventListener("click",openRule,false);
		document.getElementById('submitfulname').addEventListener("click",btnlogin,false);
		}
		// funcion btnlogin that allow user enter their name, and the name can save in localstorage
		function btnlogin()
		{
			//get the value from username textbox
			var fullname = document.getElementById("usernames1").value;
			// loop though localstorage to see the value 
			for(var i = 0; i < localStorage.length; i++)
			{
				var fullnameInStorage = localStorage.getItem(localStorage.key(i));
				// if user last time signin. the greating sentence will say welcome back
				if (fullnameInStorage == fullname)
				{
					
					localStorage.setItem("fullname", fullname);
					//document.getElementById("outputname").innerHTML = "hello";
					document.getElementById("outputname").innerHTML = "welcome back: "+localStorage.getItem(localStorage.key(i))+ " . Hoping you have a wonderful day";						
				}
				// else for first time user sign in. 
				else
				{
					
					localStorage.setItem("fullname", fullname);
					document.getElementById("outputname").innerHTML = "welcome for the first time: "+localStorage.getItem(localStorage.key(i))+ " . Hoping you have a wonderful day";
				}		
			}
			
		}
		// function to open the new window for user to read rules
		function openRule(){
			child = window.open("rules.html","", "height = 400px, width = 600px");
		}
		// function that user click button play to get 3 random number
		function playgame()
		{
			// random number will be genarate from 1 to 9
			var number1 = Math.floor(1 + Math.random() * 9);
			var number2 = Math.floor(1 + Math.random() * 9);
			var number3 = Math.floor(1 + Math.random() * 9);				
			// the array to hold each number of the random above. 
			var randomNumArray = [number1,number2,number3];
			for(var i = 0; i< 1; i++)
			{
				// display each random number in to html pages	
				document.getElementById("printresult").innerHTML = randomNumArray[i];
				document.getElementById("printresult1").innerHTML = randomNumArray[i+1];
				document.getElementById("printresult2").innerHTML = randomNumArray[i+2];
			}
			// check the condition to win the price is 777
			if(randomNumArray[0] == 7 && randomNumArray[1] == 7 && randomNumArray[2] == 7)
			{
				document.getElementById("congratulation").innerHTML = "Congratulation, you won the game and have gree meal";
			}
			else
			{
				alert("Thanks you for play the game. see you next time");	
			}
			
		}
		// function to close the window after user open the new window
		function close_window()
		{
			child.close();
			
			if (child.closed)
				alert("the window now closed");
			else
				child.close();
		}
		// function to open window 
		function open_window()
		{
			child = window.open("resgiterAccount.html","", "height = 400px, width = 600px");
			
			document.getElementById('closeW').disabled = false;
		}
		window.addEventListener("load", start, false);
	