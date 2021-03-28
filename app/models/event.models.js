module.exports = mongoose => {
    const Event = mongoose.model(
        'event',
        mongoose.Schema({
            name: String,
            date: Date,
            time: String,
            about: String,
            poster: Buffer,
            max_allowed: Number,
            theme: String,
            rating: [{
                by: {
                    type: mongoose.Schema.Types.ObjectId,
                    ref: 'user'
                },
                rate: Number
            }],
            location: String,
            category: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'category'
            },
            manager: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'manager'
            },
            sales_points: [{
                name: String,
                town: String,
                phone: String
            }],
            tickets: {
                presaleGeneral: Number,
                presaleVIP : Number, 
                presaleVVIP : Number,
                gateGeneral: Number,
                gateVIP    : Number, 
                gateVVIP   : Number ,
                createdAt : {type: Date, default: Date.now}
            }
        },{
            timestamps: true
        })
    );

    return Event;
}