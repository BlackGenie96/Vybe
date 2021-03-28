module.exports = mongoose => {

    const Category = mongoose.model(
        'category',
        mongoose.Schema({
            name: String,
            path: String,
            parent: {
                id: {type: mongoose.Schema.Types.Object, ref: 'category'},
                name: String,
            },
            has_children: Boolean
        },
        {timestamps: true}));

    return Category;
}; 