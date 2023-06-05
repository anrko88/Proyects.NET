namespace Layer.Entidad
{
    public class EN_WebF
    {

        private string categoria;
        public string Categoria
        {
            get { return categoria; }
            set { categoria = value; }
        }

        private int productID;
        public int ProductID
        {
            get { return productID; }
            set { productID = value; }
        }

        private int   unitsInStock;
        public int UnitsInStock
        {
            get { return unitsInStock; }
            set { unitsInStock = value; }
        }
        

        private double unitPrice;
        public double UnitPrice
        {
            get { return unitPrice; }
            set { unitPrice = value; }
        }

    }
}
