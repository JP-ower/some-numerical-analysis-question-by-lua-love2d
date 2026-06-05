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

    //1.二分法
    cout << "-- part 1 --" << endl;
    double left=0.5, right=1.2, epision=pow(10,-4);
    int cnt = 0;
    while(right-left > epision){
        cnt ++;
        cout << "Attempt "<< cnt << ":\t";
        double mid = (left + right)/2;
        if(fx(mid)>0){
            right = mid;
        }else{
            left = mid;
        }
        cout << "left=" << left << " \tright=" << right << endl;
    }
    cout << "Part 1 result : [" << left << " , " << right << "]" << endl;
    cout << "avg = " << (left + right)/2 << endl;
    
    return 0;
}