 resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
      Name = "talent-academy-vpc"
  }
}

# CREATING SUBNETS
# HERE IS PUBLIC SUBNET 
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "talent-academy-public-a"
    }
}

# HERE IS PRIVATEAPP SUBNET
resource "aws_subnet" "privateapp" {
    vpc_id = aws_vpc.main.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "talent-academy-privateapp-a"
    }
}

# HERE IS DATA SUBNET
resource "aws_subnet" "data" {
    vpc_id = aws_vpc.main.id
    cidr_block = "192.168.3.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "talent-academy-data-a"
    }
}

#CREATING INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
  
    tags = {
      Name = "talent-academy-igw"
    }
  }
  
  resource "aws_eip" "nat_eip" {
    vpc = true
  }


#CREATING THE NAT GATEWAY
resource "aws_nat_gateway" "nat_gw" {

    vpc_id = aws_vpc.main.id
    tags = {
        Name = "talent-academy-nat-ngw"
  }
}

#CREATING INTERNET ROUTE TABLE

resource "aws_route_table" "internet_route_table" {
    vpc_id = aws_vpc.main.id
    
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
 
    tags = {
    Name = "internet-route-table"
    }
}


#CREATING NAT ROUTE

resource "aws_route_table" "nat_route_table" {
    vpc_id = aws_vpc.main.id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat_gw.id
    }
  
    tags = {
      Name = "nat-route-table"
    }
  }

# ASSOCIATE ROUTE TABLE -- APP LAYER

resource "aws_route_table_association" "internet_route_table_association_app" {
  subnet_id      = aws_subnet.privateapp.id
  route_table_id = aws_route_table.nat_route_table.id
}

# ASSOCIATE ROUTE TABLE -- PUBLIC LAYER

resource "aws_route_table_association" "internet_route_table_association_public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.internet_route_table.id
}