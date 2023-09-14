class TimeDuration{
public:
    TimeDuration(const string fn_name = "") : _fn_name(fn_name), _start(GetMicrosecondCount()){}
    ~TimeDuration();
private:
    void ShowResult() const;
    const string FormatDuration(ulong duration)const;

private:
    ulong _start, _end;
    string _fn_name;
};

TimeDuration::~TimeDuration(){
    _end = GetMicrosecondCount();
    ShowResult();
}

void TimeDuration::ShowResult() const{
    Print(_fn_name+" elapsed: " + FormatDuration(_end - _start));
}

const string TimeDuration::FormatDuration(ulong duration)const{
        string format = "";
        if(1000000 <= duration){
            duration /= 1000000;
            format = " sec";
        }
        else if(1000 <= duration){
            duration /= 1000;
            format = " ms";
        }
        else{
            format = " mcrs";
        }        
        return IntegerToString(duration) + format;
    }

#define TIMER TimeDuration timer##__LINE__(__FUNCTION__);
#define TIMER_HINT(hint) TimeDuration timer##__LINE__(hint);