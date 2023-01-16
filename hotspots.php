<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->

  <html>
    <head>
        <title>Crime Case Database</title>
        <meta charset = "utf-8">
        <meta name = "viewport" content = "width=device-width, initial-scale=1">
        <link rel = "stylesheet" type = "text/css" href = "css/styles.css">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
        <link rel="stylesheet" href="https://unpkg.com/boxicons@latest/css/boxicons.min.css">
    </head>
    <header>
        <h2><i class="ri-criminal-fill"></i><span>CRIME CASE DATABASE</h2> 
        <div class="navbar">
            <a class="active" href="crimebase.php">Home</a>
            <a href="mostwanted.php">Most Wanted</a>
            <a href="hotspots.php">Crime Hotspots</a>
            <a href="connectedcases.php">Connected Cases</a>
            <a href="overallprogress.php">Overall Progress</a>
            <a href="about.php">About Us</a>
        </div>
    </header>
    <script type = "text/javascript" src = "js/navbar.js"></script>

        <hr />

        <h2>CRIME HOTSPOTS</h2> 
        <form method="GET" action="hotspots.php"> <!--refresh page when submitted-->
        <fieldset>
            <legend><strong>Locations with the highest number of crimes</strong></legend><br>
            <input type="hidden" id="hotspotsQueryRequest" name="hotspotsQueryRequest">
            <input type="submit" value="View Hotspots" id="hotspotsView" name="hotspotsView">
        </fieldset>
        </form>

        <hr />

        <?php
		//this tells the system that it's no longer just parsing html; it's now parsing PHP

        require 'utility.php';

        function printLocation($result) { //prints results from a select statement
            echo "<table>";
            echo "<tr><th>Location</th><th>Number of Crimes</th></tr>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["LOCATION"] . "</td><td>" . $row["LCOUNT"] . "</td></tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }


        function handleLocationRequest() {
            global $db_conn;

            $result = executePlainSQL("SELECT c1.Location, COUNT(c1.location) as lcount 
                                        FROM CrimeInCase c1 
                                        GROUP BY c1.Location
                                        HAVING COUNT(c1.location) >= ALL(SELECT COUNT(c2.Location) 
                                                                            FROM CrimeInCase c2 
                                                                            GROUP BY c2.Location)");
            printLocation($result);
        }

        // HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('hotspotsView', $_GET)) {
                    handleLocationRequest();
                }

                disconnectFromDB();
            }
        }
        
        if (isset($_GET['hotspotsView'])) {
            handleGETRequest();
        }
		?>
	</body>
</html>