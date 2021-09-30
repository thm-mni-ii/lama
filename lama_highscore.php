<?php

$servername = "localhost"; //<IP ADRESSE HIER>
$db_username = "root"; //<USERNAME HIER>
$db_password = ""; //<PASSWORT HIER>
$dbname = "myDB"; //<DB NAME HIER>>

$gameNames = [
    "1" => "Snake",
    "2" => "Flappy-Lama",
    "3" => "Affen-Leiter"
];

$conn = new mysqli($servername, $db_username, $db_password, $dbname);

if($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}

if(isset($_POST["username"]) && isset($_POST["grade"]) && isset($_POST["highscore"]) && isset($_POST["gameID"]) && isset($_POST["token"])){

$username = $_POST["username"];
$grade = $_POST["grade"];
$highscore = $_POST["highscore"];
$gameID = $_POST["gameID"];
$token = $_POST["token"];

//Verified den Token => Ist der Highscore legitim?
if(password_verify($username.$grade.$highscore.$gameID, $token)){


$select = "SELECT highscore FROM highscores WHERE username='$username' AND grade='$grade' AND gameID='$gameID'";
$result = $conn->query($select);

if ($result->num_rows > 0) {
    //Updatet den Highscore wenn für den Nutzernamen und die Klasse und die gameID bereits ein highscore existiert. 
    $row = $result->fetch_assoc();
    //Updatet den Highscore nur wenn er größer ist als der existente?
    if(intval($highscore) > intval($row["highscore"])){
        $sql = "UPDATE highscores SET highscore='$highscore' WHERE username='$username' AND grade='$grade' AND gameID='$gameID'";
        if($conn->query($sql) == TRUE){
            echo "Records updated succesfully";
        }else{
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
    }
}else{
    //Fügt neuen highscore ein wenn noch keiner für diesen Nutzer, diese Klasse und dieses Spiel existiert
    $sql = "INSERT INTO highscores (username, grade, highscore, gameID) VALUES ('$username', '$grade', '$highscore', '$gameID')";
    if($conn->query($sql) == TRUE){
        echo "New record created succesfully";
    }else{
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}
}else{
    echo "Token does not match!";
}
}else{
    if(isset($_GET["grade"]) && isset($_GET["gameID"])){
        $grade = $_GET["grade"];
        $gameID = $_GET["gameID"];
        $select = "SELECT highscore, username FROM highscores WHERE grade='$grade' AND gameID='$gameID' ORDER BY highscore DESC LIMIT 5";
        $result = $conn->query($select);
        echo "Platz | Nutzername | Highscore | Spiel<br>";
        echo "---------------------------------------------<br>";
        if ($result && $result->num_rows > 0) {
            $rowID = 1;
            while($row = $result->fetch_assoc()) {
              echo $rowID . ". | " . $row["username"]. " | " . $row["highscore"]. " | " . $gameNames[$gameID]. "<br>";
              $rowID = $rowID + 1;
            }
        }else{
            echo "Keine Highscores für dieses Spiel in dieser Klasse!";
        }
    }
    else
        echo "Bitte eine Klasse und eine SpieleID angeben!";
}
$conn->close();
?>