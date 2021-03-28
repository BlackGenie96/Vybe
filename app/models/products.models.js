module.exports = mongoose => {
    const Product = mongoose.model(
        'product',
        mongoose.Schema({
            name: String,
            description: String,
            price: String,
            quantity: String,
            image: Buffer,  
            owned_by: {type: mongoose.Schema.Types.ObjectId, ref: 'business'}
        },
        {
            timestamps: true
        })
    );

    return Product;
}