INDEX
<?php
    require_once 'connect.php';
    include 'get_table.php';
    include 'view_table.php';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Projekt 1</title>
</head>
<body>
    
<?php
    $table = new ViewTable();
    $table->showTable('test');
?>

</body>
</html>

VIEW TABLE
<?php

class ViewTable extends Table {
    public function showTable($name) {
        
        $result = $this->getTable($name);

        echo "<table>";
        echo "<tr>";

        while ($fieldInfo = $result->fetch_field()){
            echo "<td>".$fieldInfo->name."</td>";
        }

        echo "</tr>";

        while ($row = mysqli_fetch_assoc($result)){
            echo "<tr>";
            foreach ($row as $value) {
                echo "<td>".$value."</td>";
            }
            echo "</tr>";
        }
        
        echo "</table>";
    }
}
?>

TABLE
<?php

class Table extends Dbh {

    protected function getTable($name) {

        $sql = "SELECT * FROM $name";
        $result = $this->connect()->query($sql);
        if($result){
            $numRows = $result->num_rows;
            if ($numRows > 0) {
                return $result;
            } else {
                die("Brak danych  do przekazania");
            }
        } else {
            die("Nie udało się połączyć z bazą danych");
        }
    }
}
?>

CONNECT
<?php

class Dbh {

    protected function connect() {
        
        $config = parse_ini_file('config.ini');

        $conn = new mysqli(
            $config['servername'],
            $config['username'],
            $config['password'],
            $config['dbname'],
        );
        return $conn;
    }

}
?>
