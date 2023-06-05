
namespace Business.Aplication_Categories
{
    public  class BEProductos
    {
        private string categoryName;

        public string CategoryName
        {
            get { return categoryName; }
            set { categoryName = value; }
        }
        private string categoryID;

        public string CategoryID
        {
            get { return categoryID; }
            set { categoryID = value; }
        }
        private int productID;

        public int ProductID
        {
            get { return productID; }
            set { productID = value; }
        }
        private string productName;

        public string ProductName
        {
            get { return productName; }
            set { productName = value; }
        }
        private float unitPrice;

        public float UnitPrice
        {
            get { return unitPrice; }
            set { unitPrice = value; }
        }

      
        private int stock;

        public int Stock
        {
            get { return stock; }
            set { stock = value; }
        }
    }
}
