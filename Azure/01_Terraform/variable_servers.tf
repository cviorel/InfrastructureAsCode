variable "az_server_std_4c_28G" {
  description = "Azure Standard_DS12_v2 4c 28G"
  default = "Standard_DS12_v2" //~R 3,483.12/mo
}

variable "az_server_std_16c_56G" {
  description = "Azure Standard_DS13_v2 16c 56G"
  default = "Standard_DS12_v2" //~R 6,966.23/mo
}

variable "az_server_std_16c_112G" {
  description = "Azure Standard_DS12_v2 16c 112G"
  default = "Standard_DS14_v2" //~R 13,932.45/mo
}

variable "az_server_co_4c_8g_ps" {
  description = "Azure Compute optimized 4 core 8G premium storage "
  default = "Standard_F4s" //~R 2,470.84/mo
}

variable "az_server_co_4c_8g" {
  description = "Azure Compute optimized 4 core 8G"
  default = "Standard_F4" //~R 2,470.84/mo
}

variable "az_server_ci_8c_56g" {
  description = "Azure Compute intensive 8 core 56G"
  default = "Standard_H8" //~R 12,190.89/mo
}

variable "az_server_ci_16c_112g" {
  description = "Azure Compute intensive 16 core 112G"
  default = "Standard_H16" //~R 24,370.89/mo
}

variable "az_server_avg_8c_28g" {
  description = "Azure Compute intensive 8 core 28G"
  default = "Standard_DS4_v2" //~R 6,030.14/mo
}

variable "az_server_avg_16c_112g" {
  description = "Azure Compute intensive 16 core 112G"
  default = "Standard_DS5_v2" //~R 12,060.27/mo
}
