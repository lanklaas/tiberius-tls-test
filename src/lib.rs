use anyhow::Result;

use tiberius::{Client, Config};
use tokio::net::TcpStream;

use tokio_util::compat::{Compat, TokioAsyncWriteCompatExt};

pub const CONNECTION_QUERY: &str = "SELECT 1";

#[derive(Debug)]
pub struct MetaDb {
    config: Config,
}

impl MetaDb {
    pub fn with_jdbc_url(url: &str) -> Result<Self> {
        let mut config = Config::from_jdbc_string(url)?;
        config.trust_cert();
        Ok(Self { config })
    }

    pub async fn connect(&self) -> Result<MetaDbConnection> {
        let tcp = TcpStream::connect(self.config.get_addr()).await?;
        // We'll disable the Nagle algorithm. Buffering is handled
        // internally with a `Sink`.
        tcp.set_nodelay(true)?;
        let c = tcp.compat_write();

        // Handling TLS, login and other details related to the SQL Server.
        let client = Client::connect(self.config.clone(), c).await?;
        Ok(MetaDbConnection { connection: client })
    }
}

#[derive(Debug)]
pub struct MetaDbConnection {
    connection: Client<Compat<TcpStream>>,
}

impl MetaDbConnection {
    pub fn client_mut(&mut self) -> &mut Client<Compat<TcpStream>> {
        &mut self.connection
    }
}
