    // === ВКЛАДКА: FavoritesManager ===
    import java.io.File;
    import java.util.ArrayList;

    class FavoritesManager {
    private PApplet app;
    private String fileName = "favorites.json";
    public ArrayList<InstrumentItem> list = new ArrayList<InstrumentItem>();

    FavoritesManager(PApplet app) {
        this.app = app;
        loadFavorites();
    }

    void loadFavorites() {
        list.clear();
        String path = app.dataPath(fileName);
        File file = new File(path);
        if (!file.exists()) return;

        try {
        JSONArray jsonArray = app.loadJSONArray(path);
        for (int i = 0; i < jsonArray.size(); i++) {
            JSONObject obj = jsonArray.getJSONObject(i);
            list.add(new InstrumentItem(
            obj.getString("name"),
            obj.getString("ticker"),
            obj.getString("uid"),
            obj.getString("type")
            ));
        }
        } catch (Exception e) {
        println("Ошибка загрузки избранного: " + e.getMessage());
        }
    }

    void saveFavorites() {
        JSONArray jsonArray = new JSONArray();
        for (int i = 0; i < list.size(); i++) {
        InstrumentItem item = list.get(i);
        JSONObject obj = new JSONObject();
        obj.setString("name", item.name);
        obj.setString("ticker", item.ticker);
        obj.setString("uid", item.uid);
        obj.setString("type", item.type);
        jsonArray.setJSONObject(i, obj);
        }
        app.saveJSONArray(jsonArray, app.dataPath(fileName));
    }

    void add(InstrumentItem item) {
        if (!contains(item.uid)) {
        list.add(item);
        saveFavorites();
        }
    }

    void remove(String uid) {
        for (int i = list.size() - 1; i >= 0; i--) {
        if (list.get(i).uid.equals(uid)) {
            list.remove(i);
            saveFavorites();
            break;
        }
        }
    }

    boolean contains(String uid) {
        for (InstrumentItem item : list) {
        if (item.uid.equals(uid)) return true;
        }
        return false;
    }
}
