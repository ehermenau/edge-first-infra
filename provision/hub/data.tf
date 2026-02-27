# Fetch AZs dynamically
data "aws_availability_zones" "available" {
  state = "available"
}
