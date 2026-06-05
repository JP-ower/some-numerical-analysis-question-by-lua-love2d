#include <bits/stdc++.h>
int global_debug = 1;
#define debug(...) if(global_debug) cout << "\033[32m[" << #__VA_ARGS__ << "]\n" << __VA_ARGS__ << "\033[0m\n";
#define devec(c) if(global_debug){int devec_sz = c.size(); cout << "\033[32m[" << #c << "]\n"; for(int i=0;i<devec_sz;i++) cout << c[i] << " "; cout << "\033[0m\n";}
#define devec2(c) if(global_debug){int devec_sz = c.size(); cout << "\033[32m[" << #c << "]\n"; for(int i=0;i<devec_sz;i++){int devec_sz2 = c[i].size(); for(int j = 0;j<devec_sz2;j++) cout<< c[i][j] << " ";cout<< "\n";}cout << "\033[0m";}
#define answer(c) if(global_debug){cout << "\033[33m---OUTPUT---\n";}cout << c << "\n";if(global_debug){cout<<"\033[0m\n";}
#define answerv(c) if(global_debug){cout << "\033[33m---OUTPUT---\n";}{int answerv_size = c.size(); for(int i = 0;i<answerv_size;i++)cout << c[i] << " "; cout << "\n";}if(global_debug){cout<<"\033[0m\n";}
using namespace std;

int main(){
    auto fx = [](double x){
        return x*x*x - 6*x*x + 11*x - 6;
    };
    auto f1x = [](double x){
        return 3*x*x - 12*x + 11;
    };

    //2.Newton法
    cout << "-- part 2 --" << endl;
    vector<double> ix = {0.5,0.8,1.5,1.8,2.5,2.8};
    for(auto x:ix){
        double x0=x, tmp=x;
        cout << "-- x0=" << x0 << " --" << endl;
        int cnt = 0;
        while(true){
            cnt++;
            cout << "Attempt " << cnt << ":\t";
            x0 = x0 - fx(x0)/f1x(x0);
            cout << "x = " << x0 << endl;
            if(abs(x0-tmp) < pow(10,-4)){
                break;
            }else{
                tmp = x0;
            }
        }
        cout << "Result : " << x0 << endl;
    }
    
    return 0;
}