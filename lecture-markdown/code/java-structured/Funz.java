class Funz {
	static int fatt(int x){
		if (x <= 1){
			return 1;
		} else {
			return x * Funz.fatt(x-1);
		}
	}
}
