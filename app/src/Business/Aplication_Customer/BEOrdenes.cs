using System;

namespace Business.Aplication_Customer
{
    public class BEOrdenes
    {
        private int orderID;

        public int OrderID
        {
            get { return orderID; }
            set { orderID = value; }
        }
        private DateTime orderDate;

        public DateTime OrderDate
        {
            get { return orderDate; }
            set { orderDate = value; }
        }
           
        private string customerId;

        public string CustomerId
        {
            get { return customerId; }
            set { customerId = value; }
        }
        private double freight;

        public double Freight
        {
            get { return freight; }
            set { freight = value; }
        }
        private double compratotal;

        public double Compratotal
        {
            get { return compratotal; }
            set { compratotal = value; }
        }
    }
}
