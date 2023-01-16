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

        <h2>MOST WANTED</h2> 
        <form method="GET" action="mostwanted.php"> <!--refresh page when submitted-->
        <fieldset>
            <legend><strong>Most Wanted Criminal</strong></legend><br>
            <input type="hidden" id="mostWantedQuery" name="mostWantedQuery">
            Criminal(s) involved in <input type="number" min=0 step=1 id="numCases" name="numCases"> case(s)<br /><br> 

            <input type="submit" value="Find Most Wanted" name="mostWantedSubmit"></p>
        </fieldset>
        </form>

        <hr />

        <?php
		//this tells the system that it's no longer just parsing html; it's now parsing PHP

        require 'utility.php';
        function printMostWantedResult($result) { //prints results from a select statement
            $numCases = $_GET['numCases'];
            echo "Criminal(s) involved in >= $numCases cases:";
            echo "<table>";
            echo "<tr><th>Criminal ID</th><th>Name</th><th>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["CID"] . "</td><td>" . $row["NAME"] . "</td><td>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }


        function handleMostWantedRequest() {
            $mostWanted = $_GET['numCases'];
            if ($mostWanted == null) {
                $mostWanted = 0;
            }
            $result = executePlainSQL("SELECT Criminal.CID, Criminal.Name
                                        FROM Cases
                                        JOIN CommitCrime ON Cases.CAID = CommitCrime.CAID
                                        JOIN Criminal ON CommitCrime.CID = Criminal.CID
                                        GROUP BY Criminal.CID, Criminal.Name, Criminal.TimesArrested
                                        HAVING COUNT(Cases.CAID) >= ".$mostWanted
                                    );
            // echo $mostWanted;         
            printMostWantedResult($result);
        }

        // HANDLE ALL GET ROUTES
	    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('numCases', $_GET)) {
                    handleMostWantedRequest();
                }

                disconnectFromDB();
            }
        }

        if (isset($_GET['mostWantedSubmit'])) {
            handleGETRequest();
        }
		?>
	</body>
</html>