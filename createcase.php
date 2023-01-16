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

    <body>
        <hr />
        <h2>CREATE NEW CASE FILE</h2>
        <form method="POST" action="createcase.php"> 
        <fieldset>
            Date: <input type="date" id="date" name="date"><br><br>
            Case ID: <input type="number" min="0" step="1" id="caseid" name="caseid" value=""><br><br>
            <input type="submit" value="Create File" name = "createFile" >
        </fieldset>
        </form>
        <hr />

        <?php
		//this tells the system that it's no longer just parsing html; it's now parsing PHP

        require 'utility.php';

        function handleInsertRequest() {
            global $db_conn;
            
            $caid = $_POST['caseid'];
            $date = $_POST['date'];
            
            executePlainSQL("INSERT INTO Cases VALUES ($caid, DATE '$date', 'N/A', 'Active')");
            OCICommit($db_conn);
        }

        // HANDLE ALL POST ROUTES
	    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handlePOSTRequest() {
            if (connectToDB()) {
                if (array_key_exists('createFile', $_POST)) {
                    handleInsertRequest();
                }

                disconnectFromDB();
            }
        }

		if (isset($_POST['createFile'])) {
            handlePOSTRequest();
        }
		?>
	</body>
</html>