
  <html>
    <head>
        <title>Crime Case Database</title>
        <meta charset = "utf-8">
        <meta name = "viewport" content = "width=device-width, initial-scale=1">
        <link rel = "stylesheet" type = "text/css" href = "css/styles.css">
        <link href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css" rel="stylesheet">
        <link rel="stylesheet" href="https://unpkg.com/boxicons@latest/css/boxicons.min.css">
    </head>
    <head>
        <h2><i class="ri-criminal-fill"></i><span>CRIME CASE DATABASE</h2> 
        <div class="navbar">
            <a class="active" href="crimebase.php">Home</a>
            <a href="mostwanted.php">Most Wanted</a>
            <a href="hotspots.php">Crime Hotspots</a>
            <a href="connectedcases.php">Connected Cases</a>
            <a href="overallprogress.php">Overall Progress</a>
            <a href="about.php">About Us</a>
        </div>
    </head>
    <script type = "text/javascript" src = "js/navbar.js"></script>

    <body style = "font-family: 'Monaco', monospace">
        <hr />
        <h2>CRIMEBASE</h2> 
        <form method="GET" action="crimebase.php"> <!--refresh page when submitted-->
        <fieldset>
            <legend><strong>Case Management</strong>&nbsp;&nbsp;&nbsp;<a href="createcase.php">Create New Case +</a>&nbsp;&nbsp;&nbsp;
            <a href="updatecase.php">Update Case ~</a>&nbsp;&nbsp;&nbsp;
            <a href="deletecase.php">Delete Case -</a></legend><br>
            <!-- <input type="submit" value="View Status" name = "viewCaseStatus"><br /><br /> -->
            View from all Cases:<br />
            <input type="checkbox" name="criteria[]" value="CAID">
            <label> Case ID</label><br>
            <input type="checkbox" name="criteria[]" value="DateLogged">
            <label> Date Logged</label><br>
            <input type="checkbox" name="criteria[]" value="Result">
            <label> Result</label><br>
            <input type="checkbox" name="criteria[]" value="CaseStatus">
            <label> Case Status</label><br><br>
            <input type="submit" value="Retrieve Cases" name = "retrieveCases"> 
        </fieldset>
        </form>
        <form method="GET" action="crimebase.php">
        <fieldset>
            <legend><strong>Search A Specific Case</strong></legend><br>
            Case Number: <input type="number" min="0" step="1" id="caseNo" name="caseNo"> <br /><br>
            <input type="submit" value="See More Info" name = "viewMoreInfo">
        </fieldset>
        </form>
        <form method="GET" action="crimebase.php"> <!--refresh page when submitted-->
        <fieldset>
            <legend><strong>Police Force Personnel</strong></legend></br>
            Search for: 
            <select id="selection" name="selection">
                <option hidden disabled selected value></option>
                <option value="Detective">Detective</option>
                <option value="PoliceChief">Police Chief</option>
            </select><br><br>
            Badge Number: <input type="number" min="0" step="1" id="badgeNo" name="badgeNo"> <br /><br />
            <input type="submit" value="Search" name = "viewOfficer">
            <input type="submit" value="View Cases (detective only)" name="viewCases">
        </fieldset>
        </form>
        <hr />

        <?php

        require 'utility.php';
        
        function printCases($result, $arr) {
            $strings = array_map('strval', $arr); //https://stackoverflow.com/questions/2131462/how-to-cast-array-elements-to-strings-in-php
            echo "<table>";
            echo "<tr>";
            foreach ($strings as $s) {
                echo "<th>$s</th>";
            }
            echo "<tr>";
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>";
                foreach ($strings as $s) {
                    $s = strtoupper($s);
                    echo "<td>$row[$s]</td>";
                }
                echo "</tr>"; //or just use "echo $row[0]"
            }
            echo "</table>";
        }

        function printMoreInfo($result) { //prints results from a select statement
            echo "<table>";
            echo "<tr><th>CAID </th><th>DateLogged </th><th>Detective </th><th>CrimeType </th><th>CrimeLocation </th></tr>";
            
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["CAID"] . "</td><td>" . $row["DATELOGGED"] . "</td><td>" . $row["NAME"] . "</td>
                <td>" . $row["CRIMETYPE"] . "</td><td>" . $row["LOCATION"] . "</td></tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }

        function printDetective($result) { //prints results from a select statement
            echo "<table>";
            echo "<tr><th>Badge</th><th>PoliceChiefBadge</th><th>Precinct#</th><th>Name</th><th>Rank</th><th>Phone#</th></tr>";
            
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["DBADGENUMBER"] . "</td><td>" . $row["PCBADGENUMBER"] . "</td><td>" . $row["PRECINCTNUMBER"] . "</td>
                <td>" . $row["NAME"] . "</td><td>" . $row["RANK"] . "</td><td>" . $row["PHONENUMBER"] . "</td></tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }

        function printPoliceChief($result) { //prints results from a select statement
            echo "<table>";
            echo "<tr><th>Badge</th><th>Name</th><th>Phone#</th></tr>";
            
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["BADGENUMBER"] . "</td><td>" . $row["NAME"] . "</td><td>" . $row["PHONENUMBER"] . "</td></tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }

        function printDCM($result) {
            echo "<table>";
            echo "<tr><th>BadgeNumber</th><th>Case ID</th></tr>";
            
            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["BADGENUMBER"] . "</td><td>" . $row["CAID"] . "</td></tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }

        function handleCasesRequest() {
            global $db_conn;
            $arr = array();
            $temparr = $_GET['criteria'];
            foreach ($temparr as $criteria) {
                array_push($arr, $criteria);
            }
            $cols = implode(", ", $arr);
            $result = executePlainSQL("SELECT $cols FROM Cases");
            printCases($result, $arr);
        }


        function handleMoreInfoRequest() {
            global $db_conn;
            $caseNo = $_GET['caseNo'];
            $result = executePlainSQL("SELECT Cases.CAID, Cases.DateLogged, Detective.Name, CrimeInCase.CrimeType, CrimeInCase.Location FROM Cases 
                                            FULL OUTER JOIN DetectiveCaseManagement ON 
                                                       DetectiveCaseManagement.CAID = Cases.CAID 
                                            FULL OUTER JOIN Detective ON 
                                                       DetectiveCaseManagement.BadgeNumber = Detective.DBadgeNumber
                                            FULL OUTER JOIN CrimeInCase ON 
                                                       Cases.CAID = CrimeInCase.CAID 
                                            WHERE Cases.CAID = $caseNo");

            printMoreInfo($result);
        }

        function handleOfficerRequest() {
            global $db_conn;
            $selection = $_GET['selection'];
            $badgeNo = $_GET['badgeNo'];
            if ($selection == "Detective") {
                $result = executePlainSQL("SELECT * FROM $selection WHERE DBadgeNumber = $badgeNo");
                printDetective($result);
            } else if ($selection == "PoliceChief") {
                $result = executePlainSQL("SELECT * FROM $selection WHERE BadgeNumber = $badgeNo");
                printPoliceChief($result);
            }

        }

        function handleDCMRequest() {
            global $db_conn;
            $selection = $_GET['selection'];
            $badgeNo = $_GET['badgeNo'];
            if ($selection == "Detective") {
                $result = executePlainSQL("SELECT * FROM DetectiveCaseManagement WHERE BadgeNumber = $badgeNo");
                printDCM($result);
            } else {
                echo "Not a detective!";
            }
        }

        // HANDLE ALL GET ROUTES
	// A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('retrieveCases', $_GET)) {
                    handleCasesRequest();
                } else if (array_key_exists('viewMoreInfo', $_GET)) {
                    handleMoreInfoRequest();
                } else if (array_key_exists('viewOfficer', $_GET)) {
                    handleOfficerRequest();
                } else if (array_key_exists('viewCases', $_GET)) {
                    handleDCMRequest();
                } 
                disconnectFromDB();
            }
        }

            // HANDLE ALL GET ROUTES
        // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.

        if (isset($_GET['retrieveCases']) || isset($_GET['viewMoreInfo']) || isset($_GET['viewOfficer']) || isset($_GET['viewCases'])) {
            handleGETRequest();
        }
		?>
	</body>
</html>