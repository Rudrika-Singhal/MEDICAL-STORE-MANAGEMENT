<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Medical Store Management System</title>
<style>
body { background:#f0f0f0; font-family: Arial, sans-serif; }
.container { width:900px; margin:40px auto; background:white; padding:20px; border-radius:10px; box-shadow:0 0 10px gray; }
h2 { text-align:center; margin-bottom:20px; }
input, select, button { width:100%; padding:10px; margin:5px 0; }
button { border:none; border-radius:5px; font-size:16px; cursor:pointer; color:white; }
.add { background:#28a745; }
.view { background:#007bff; }
.delete { background:#dc3545; }
.update { background:#ffc107; color:black; }
table { width:100%; border-collapse: collapse; margin-top:20px; }
table, th, td { border:1px solid #aaa; text-align:center; }
th { background:black; color:white; }
td { padding:5px; }
.low-stock { background:#f8d7da; }
.msg { margin-top:10px; text-align:center; font-weight:bold; }
</style>

<script>
function checkAddUpdate() {
    let id=document.getElementById("id").value;
    let name=document.getElementById("name").value;
    let company=document.getElementById("company").value;
    let price=document.getElementById("price").value;
    let quantity=document.getElementById("quantity").value;
    let batch=document.getElementById("batch").value;
    let expiry=document.getElementById("expiry").value;
    if(id=="" || name=="" || company=="" || price=="" || quantity=="" || batch=="" || expiry=="") {
        alert("All fields are required!");
        return false;
    }
    return true;
}

function checkDelete() {
    let id=document.getElementById("id").value;
    if(id=="") { alert("Enter ID to delete!"); return false; }
    return true;
}
</script>

</head>
<body>
<div class="container">
<h2>Medical Store Management System</h2>

<form method="post">
    <input type="number" id="id" name="id" placeholder="Medicine ID">
    <input type="text" id="name" name="name" placeholder="Medicine Name">
    <input type="text" id="company" name="company" placeholder="Company">
    <input type="number" id="price" name="price" placeholder="Price">
    <input type="number" id="quantity" name="quantity" placeholder="Quantity">
    <input type="text" id="batch" name="batch" placeholder="Batch Number">
    <input type="date" id="expiry" name="expiry" placeholder="Expiry Date">

    <button type="submit" name="action" value="add" class="add" onclick="return checkAddUpdate()">Add Medicine</button>
    <button type="submit" name="action" value="update" class="update" onclick="return checkAddUpdate()">Update Medicine</button>
    <button type="submit" name="action" value="delete" class="delete" onclick="return checkDelete()">Delete Medicine</button>
    <button type="submit" name="action" value="view" class="view">View All Medicines</button>
</form>

<div class="msg">
<%
String url="jdbc:mysql://localhost:3306/medicaldb";
String user="root";
String pass="rudrika05@R";
Connection con=null;
PreparedStatement pst=null;
ResultSet rs=null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection(url,user,pass);
    String action=request.getParameter("action");

    if(action!=null) {

    // ===== ADD =====
    if("add".equals(action)) {
        String idStr=request.getParameter("id");
        String priceStr=request.getParameter("price");
        String qtyStr=request.getParameter("quantity");
        if(idStr==null||idStr.trim().equals("")||priceStr==null||priceStr.trim().equals("")||qtyStr==null||qtyStr.trim().equals("")) {
            out.print("<p style='color:red;'>ID, Price, Quantity required!</p>");
        } else {
            int id=Integer.parseInt(idStr);
            String name=request.getParameter("name");
            String company=request.getParameter("company");
            double price=Double.parseDouble(priceStr);
            int quantity=Integer.parseInt(qtyStr);
            String batch=request.getParameter("batch");
            String expiry=request.getParameter("expiry");

            pst=con.prepareStatement("INSERT INTO medstore VALUES (?,?,?,?,?,?,?)");
            pst.setInt(1,id); pst.setString(2,name); pst.setString(3,company);
            pst.setDouble(4,price); pst.setInt(5,quantity); pst.setString(6,batch); pst.setString(7,expiry);
            pst.executeUpdate();
            out.print("<p style='color:green;'>Medicine Added Successfully ✔</p>");
        }
    }

    // ===== UPDATE =====
    else if("update".equals(action)) {
        String idStr=request.getParameter("id");
        if(idStr==null||idStr.trim().equals("")) {
            out.print("<p style='color:red;'>Enter ID to Update!</p>");
        } else {
            int id=Integer.parseInt(idStr);
            String name=request.getParameter("name");
            String company=request.getParameter("company");
            String priceStr=request.getParameter("price");
            String qtyStr=request.getParameter("quantity");
            double price = priceStr==null||priceStr.trim().equals("")?0:Double.parseDouble(priceStr);
            int quantity = qtyStr==null||qtyStr.trim().equals("")?0:Integer.parseInt(qtyStr);
            String batch=request.getParameter("batch");
            String expiry=request.getParameter("expiry");

            pst=con.prepareStatement("UPDATE medstore SET name=?, company=?, price=?, quantity=?, batch_number=?, expiry_date=? WHERE id=?");
            pst.setString(1,name); pst.setString(2,company); pst.setDouble(3,price); pst.setInt(4,quantity);
            pst.setString(5,batch); pst.setString(6,expiry); pst.setInt(7,id);
            int count=pst.executeUpdate();
            if(count>0) out.print("<p style='color:orange;'>Medicine Updated Successfully ✔</p>");
            else out.print("<p style='color:red;'>No Medicine Found with this ID!</p>");
        }
    }
    //File created
    // ===== DELETE =====
    else if("delete".equals(action)) {
        String idStr=request.getParameter("id");
        if(idStr==null||idStr.trim().equals("")) {
            out.print("<p style='color:red;'>Enter ID to Delete!</p>");
        } else {
            int id=Integer.parseInt(idStr);
            pst=con.prepareStatement("DELETE FROM medstore WHERE id=?");
            pst.setInt(1,id);
            int count=pst.executeUpdate();
            if(count>0) out.print("<p style='color:red;'>Medicine Deleted Successfully ✔</p>");
            else out.print("<p style='color:red;'>No Medicine Found with this ID!</p>");
        }
    }

    // ===== VIEW ALL =====
    else if("view".equals(action)) {
        pst=con.prepareStatement("SELECT * FROM medstore");
        rs=pst.executeQuery();
        double totalValue=0;
        boolean found=false;

        out.print("<table>");
        out.print("<tr><th>ID</th><th>Name</th><th>Company</th><th>Price</th><th>Quantity</th><th>Batch</th><th>Expiry</th></tr>");
        while(rs.next()) {
            found=true;
            int qty=rs.getInt("quantity");
            totalValue += rs.getDouble("price")*qty;
            String rowClass = qty<5 ? "low-stock" : "";
            out.print("<tr class='"+rowClass+"'>");
            out.print("<td>"+rs.getInt("id")+"</td>");
            out.print("<td>"+rs.getString("name")+"</td>");
            out.print("<td>"+rs.getString("company")+"</td>");
            out.print("<td>"+rs.getDouble("price")+"</td>");
            out.print("<td>"+qty+"</td>");
            out.print("<td>"+rs.getString("batch_number")+"</td>");
            out.print("<td>"+rs.getDate("expiry_date")+"</td>");
            out.print("</tr>");
        }
        out.print("</table>");
        if(!found) out.print("<p style='color:red;'>No medicines found!</p>");
        else out.print("<p>Total Inventory Value: ₹"+totalValue+"</p>");
    }
    }

} catch(Exception e) {
    out.print("<p style='color:red;'>Error: "+e+"</p>");
}
%>
</div>
</div>
</body>
</html>



