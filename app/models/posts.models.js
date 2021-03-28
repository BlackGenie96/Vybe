module.exports = mongoose => {

    const postSchema = mongoose.Schema({
        status: String,
        image: Buffer,
        category: {type: mongoose.Schema.Types.ObjectId, ref:'category'},
        post_by_user: {type: mongoose.Schema.Types.ObjectId, ref: 'user'},
        post_by_manager: {type: mongoose.Schema.Types.Object, ref: 'manager'},
        post_about_business: {type: mongoose.Schema.Types.ObjectId, ref: 'business'},
        post_about_event: {type: mongoose.Schema.Types.ObjectId, ref: 'event'},
        likes : [{
            user: {type: mongoose.Schema.Types.ObjectId, ref:'user'},
            createdAt: {
                type: Date,
                default: Date.now
            }
        }],
        comments: [{
            user: {type: mongoose.Schema.Types.ObjectId, ref:'user'},
            manager: {type: mongoose.Schema.Types.ObjectId, ref:'manager'},
            createdAt: {
                type: Date,
                default: Date.now
            },
            text: String
        }]
    },{
        timestamps: true
    });

    const Post = mongoose.model('posts',postSchema);

    return Post;
}