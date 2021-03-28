let bcrypt = require("bcrypt");

module.exports = mongoose => {

    const managerSchema = new mongoose.Schema({
        name: String,
        surname: String, 
        email: String, 
        phone: String,
        password: String,
        image : Buffer,
        payment: Date,
    },{
        timestamps: true
    });

    managerSchema.pre('save', async function(next){
        const manager = this;

        if(manager.isModified("password")){
            manager.password = await bcrypt.hash(manager.password, 10);
        }

        next();
    });

    managerSchema.methods.hashPassword = async function(){
        let res;
        
        res = await bcrypt.hash(this.password, 10);
        return res;
    };

    managerSchema.methods.validatePassword = async function(newPass){
        let res;
        await bcrypt.compare(newPass, this.password).then(val =>{
            res = val;
        });

        return res;
    };

    const Manager = mongoose.model(
        'manager',
        managerSchema
    );

    return Manager;
}