<?php
// 'product' object
class Product{
	//=======================================
	
	//=======================================
    // database connection and table name
    private $conn;
    private $table_name="sp_phones";
 
    // object properties
    public $id;
    public $name;
    public $price;
    public $description;
	public $storageGB;
	public $grade;
    public $category_id;
   public $category_name;
   public $timestamp;
 
    // constructor
    public function __construct($db){
        $this->conn = $db;
    }
	//================================
	function readFirst(){
 
    // select query
    $query = "SELECT  idSmartPhones,Description, ProductName, price, storageGB, grade
            FROM sp_phones
            WHERE idSmartPhones = ?         
            LIMIT 0, 1";
 
    // prepare query statement
    $stmt = $this->conn->prepare( $query );
 
    // sanitize
    $this->id=htmlspecialchars(strip_tags($this->idSmartPhones));
 
    // bind prodcut id variable
    $stmt->bindParam(1, $this->idSmartPhones);
 
    // execute query
    $stmt->execute();
 
    // return values
    return $stmt;
}
	
	//====================================
	// read all products
function read($from_record_num, $records_per_page){
 
    // select all products query
    $query = "SELECT
                idSmartPhones, ProductName, Description, price, storageGB, grade 
            FROM
                " . $this->table_name . "
            ORDER BY
                ProductName DESC
            LIMIT
                ?, ?";
 
    // prepare query statement
    $stmt = $this->conn->prepare( $query );
 
    // bind limit clause variables
    $stmt->bindParam(1, $from_record_num, PDO::PARAM_INT);
    $stmt->bindParam(2, $records_per_page, PDO::PARAM_INT);
 
    // execute query
    $stmt->execute();
 
    // return values
    return $stmt;
}
 
// used for paging products
public function count(){
 
    // query to count all product records
    $query = "SELECT count(*) FROM " . $this->table_name;
 
    // prepare query statement
    $stmt = $this->conn->prepare( $query );
 
    // execute query
    $stmt->execute();
 
    // get row value
    $rows = $stmt->fetch(PDO::FETCH_NUM);
 
    // return count
    return $rows[0];
}
//=======================================
// read all product based on product ids included in the $ids variable
// reference http://stackoverflow.com/a/10722827/827418
public function readByIds($ids){
 
    $ids_arr = str_repeat('?,', count($ids) - 1) . '?';
 
    // query to select products
    $query = "SELECT idSmartPhones, ProductName, price, storageGB, grade FROM " . $this->table_name . " WHERE idSmartPhones IN ({$ids_arr}) ORDER BY ProductName";
 
    // prepare query statement
    $stmt = $this->conn->prepare($query);
 
    // execute query
    $stmt->execute($ids);
 
    // return values from database
    return $stmt;
}
//================read product detail one for detail product page=====================
// used when filling up the update product form
function readOne(){
 
    // query to select single record
    $query = "SELECT
                	ProductName, Description, price, storageGB, grade
            FROM
                " . $this->table_name . "
            WHERE
                	idSmartPhones = ?
            LIMIT
                0,1";
 
    // prepare query statement
    $stmt = $this->conn->prepare( $query );
 
    // sanitize
    $this->id=htmlspecialchars(strip_tags($this->id));
 
    // bind product id value
    $stmt->bindParam(1, $this->id);
 
    // execute query
    $stmt->execute();
 
    // get row values
   $row = $stmt->fetch(PDO::FETCH_ASSOC);
 
    // assign retrieved row value to object properties
    $this->name = $row['ProductName'];
    $this->description = $row['Description'];
    $this->price = $row['price'];
	$this->storageGB = $row['storageGB'];
    $this->grade = $row['grade'];
}
//====================================
}