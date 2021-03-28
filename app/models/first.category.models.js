module.exports = mongoose => {
    const CategorySchema = mongoose.Schema({
        name: String,
        slug: {type: String, index: true},
        parent: {
            type: mongoose.Schema.Types.ObjectId,
            default: null,
            ref : 'Category'
        },
        ancestors: [{
            _id : {
                type: mongoose.Schema.Types.ObjectId,
                ref: "Category",
                index: true
            },
            name: String,
            slug: String
        }]
    });

    CategorySchema.pre("save",async function(next){
        this.slug = slugify(this.name);
        next();
    });

    CategorySchema.methods.buildAncestors = async (id, parent_id) => {
        let ancest = [];
        try{
            let parent_category = await Category.findOne({"_id":parent_id}, {"name":1, "slug":1, "ancestors":1}).exec();

            if(parent_category){
                const {_id, name, slug} = parent_category;
                const ancest = [...parent_category.ancestors];
                ancest.unshift({_id, name, slug});
                const category = await Category.findByIdAndUpdate(id, {
                    $set: {"ancestors": ancest}
                });
            }
        }catch(err){
            console.log(err.message);
        }
    }

    const Category = mongoose.model(
        'category',
        CategorySchema);

    return Category;
};

function slugify(string){
    const a = 'àáâäæãåāăąçćčđďèéêëēėęěğǵḧîïíīįìłḿñńǹňôöòóœøōõőṕŕřßśšşșťțûüùúūǘůűųẃẍÿýžźż·/_,:;';
    const b = 'aaaaaaaaaacccddeeeeeeeegghiiiiiilmnnnnoooooooooprrsssssttuuuuuuuuuwxyyzzz------';
    const p = new RegExp(a.split('').join('|'), 'g');

    return string.toString().toLowerCase()
        .replace(/\s+/g, '-')
        .replace(p, c => b.charAt(a.indexOf(c)))
        .replace(/&/g, '-and-')
        .replace(/[^\w\-]+/g, '')
        .replace(/\-\-+/g, '-')
        .replace(/^-+/, '')
        .replace(/-+$/, '');
}