<?php
    function db_connection(){
        $host = 'localhost';
        $db = 'buses_stops';
        $user = 'postgres';
        $password = '12345';
    
        $connection_string = "host=$host dbname=$db user=$user password=$password";
        $connection = pg_connect($connection_string);
    
        if (!$connection) {
            echo "Connection failed: " . pg_last_error();
            exit;
        }
    
        return $connection;
    }
?>