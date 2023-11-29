#define DEBUG_INFO(X) debug_info(#X, X)

class debug_info{
    string _comment;

public:
        debug_info(const string var, const string val){Comment(""); _comment = var; _comment += val;}
       ~debug_info(){Comment(_comment);}

private:
    void fill_comment(const string comment);
};

void debug_info::fill_comment(const string comment){
    
}