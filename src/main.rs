use std::env;

use tiberius_tls::MetaDb;
fn get_env_var(name: &'static str) -> String {
    let msg = format!("The service requires {} environment variable", name);
    env::vars()
        .find(|(key, _)| key == name)
        .map(|(_, val)| val)
        .expect(&msg)
}

#[tokio::main]
async fn main() {
    let url = get_env_var("JDBC_URL");
    let db = MetaDb::with_jdbc_url(&url).unwrap();
    println!("Connecting to db...");
    let mut connection = db.connect().await.unwrap();
    println!("Connected");
    let s = connection
        .client_mut()
        .simple_query("SELECT 1")
        .await
        .unwrap()
        .into_first_result()
        .await
        .unwrap();
    dbg!(s);
}
