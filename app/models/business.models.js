module.exports = mongoose => {
    const Business = mongoose.model(
        'business',
        mongoose.Schema({
            name: String,
            address: String,
            phone_number : String,
            image: Buffer,
            rating: String,
            latitude: String,
            longitude: String,
            website: String,
            about: String,
            directions: String,
            category: {type: mongoose.Schema.Types.ObjectId, ref: 'category'},
            created_by: {type: mongoose.Schema.Types.ObjectId, ref: 'manager'},
            menu: [{
                name: String,
                description: String,
                price: Number,
                image: Buffer
            }]
        },{
            timestamps: true
        })
    );

    return Business;
}