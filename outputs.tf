



output "azvm_public_ip" {
  value = azurerm_public_ip.azvm_pub_ip.ip_address
}


output "awsvm_public_ip" {
  value = aws_instance.awsvm.public_ip
}
