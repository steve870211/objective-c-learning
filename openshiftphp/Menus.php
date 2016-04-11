<?php

//step2. read from mysql
$connection = mysqli_connect("localhost","root","root","OrderEasy");
mysqli_query($connection,"set names 'utf8'");
//mysqli_set_charset($connection,"utf8");
if ( mysqli_connect_errno()){
    die("Can't establish connection from database, ".mysqli_connect_error());
}

$query = "select * from Menus ";
$result = mysqli_query($connection,$query);
if ( !$result){
    die("can't execute query ");
}
?>


<?php
    $menus = array();
    while( $row = mysqli_fetch_assoc($result)){
        $menu = array();
        $menu["shopName"] = $row["shopName"];
        $menu["foodID"] = $row["foodID"];
        $menu["shopID"] = $row["shopID"];
        $menu["foodName"] = $row["foodName"]; //(int)
        $menu["price"] = $row["price"];
        $menu["foodPhoto"] = $row["foodPhoto"];
        $menus[] = $menu;
    }
    mysqli_free_result($result);
    echo json_encode($menus);
?>



<?php
mysqli_close($connection);
?>
