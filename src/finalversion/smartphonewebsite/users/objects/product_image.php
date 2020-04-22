<?php
// 'product image' object
class ProductImage{
 
    // database connection and table name
    private $conn;
    private $table_name = "product_images";
    private $table1_name = "sp_phones";
    // object properties
    public $id;
    public $idSmartPhones;
    public $name;
    public $timestamp;
 
    // constructor
    public function __construct($db){
        $this->conn = $db;
    }
	// read the first product image related to a product
function readFirst(){
 
    // select query
    $query = "SELECT id, idSmartPhones, name, productName
            FROM  product_images
            WHERE idSmartPhones  = ?         
            LIMIT 0, 1";
 
    // prepare query statement
    $stmt = $this->conn->prepare( $query );
 
    // sanitize
    $this->idSmartPhones=htmlspecialchars(strip_tags($this->idSmartPhones));
 
    // bind prodcut id variable
    $stmt->bindParam(1, $this->idSmartPhones);
 
    // execute query
    $stmt->execute();
 
    // return values
    return $stmt;
}
//===================read image to display in product detail==========
// read all product image related to a product
function readByProductId(){
 
    // select query
    $query = "SELECT id, idSmartPhones, name
            FROM " . $this->table_name . "
            WHERE idSmartPhones = ?
            ORDER BY name ASC";
 
    // prepare query statement
    $stmt = $this->conn->prepare( $query );
 
    // sanitize
    $this->idSmartPhones=htmlspecialchars(strip_tags($this->idSmartPhones));
 
    // bind prodcut id variable
    $stmt->bindParam(1, $this->idSmartPhones);
 
    // execute query
    $stmt->execute();
 
    // return values
    return $stmt;
}
}