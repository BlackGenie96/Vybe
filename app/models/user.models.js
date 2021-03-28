let bcrypt = require("bcrypt");

module.exports = mongoose => {

    const userSchema = new mongoose.Schema({
        name: String,
        surname: String, 
        email: String, 
        phone: String, 
        password: String,
        image: Buffer,
        current_category: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'category'
        }
    },
    {
        timestamps: true
    });

    userSchema.pre('save',async function(next) {
        const user = this;

        if(user.isModified("password")){
            user.password = await bcrypt.hash(user.password, 10);
        }

        console.log(user.password);

        next();
        
    });

    userSchema.methods.checkPassword = async function(newPass){
    
        let res;
        await bcrypt.compare(newPass, this.password).then(val => { 
            res = val;
        });

        return res;

    };

    const User = mongoose.model(
        'user',
        userSchema   
    );

    return User;
}