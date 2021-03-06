module API.PouchDB
          (
            PouchDBM,
            PouchDB,
            PouchDBEff,
            Adapter(..),
            StorageType(..),
            AndroidDBImplementation(..),
            PouchDBOptions(..),
            PouchDBInfo(..),
            PouchDBResponse(..),
            PouchDBDocument(..),
            logRaw,
            pouchDB,
            info,
            destroy,
            put
          ) where

import Prelude
import Data.Maybe
import Data.List
import Control.Monad.Eff             (Eff)
import Control.Monad.Eff.Console     (CONSOLE())
import Control.Monad.Eff.Exception

-- | PouchDB Effects & Types
foreign import data PouchDBM :: !
foreign import data PouchDB  :: *

type PouchDBEff a = forall e. Eff(pouchDBM :: PouchDBM | e) a

data Adapter = IDB | LevelDB | WebSQL | Http
data StorageType = Persistent | Temporary
data AndroidDBImplementation = SQLite4Java | NativeAPI

data PouchDBResponse a = PouchDBResponse a |
          SimpleResponse {
            "ok" :: Boolean
          }

data PouchDBOptions a =
            DefaultDBOptions {
              "name" :: String
            }
          | LocalDBOptions {
              "auto_compaction" :: Boolean,
              "adapter"         :: Adapter,
              "revs_limit"      :: Int
            }
          | RemoteDBOptions {
              "ajax.cache"           :: Boolean,
              "ajax.headers"         :: List String,
              "auth.username"        :: String,
              "auth.password"        :: String,
              "ajax.withCredentials" :: Boolean
            }
          | IndexedDBOptions {
              "storage" :: StorageType
            }
          | WebSQLOptions {
              "size" :: Int
            }
          | OtherDBOptions a

data PouchDBDocument a = PouchDBDocument a

data PouchDBInfo = PouchDBInfo {
  "db_name"    :: String,
  "doc_count"  :: Number,
  "update_seq" :: Number
}

-- | Logging helper
foreign import logRaw :: forall a e. a -> Eff (console :: CONSOLE | e) Unit

-- | PouchDB API
foreign import pouchDB :: forall a e. Maybe String -> Maybe (PouchDBOptions a) -> Eff (err :: EXCEPTION | e) PouchDB
foreign import info    :: forall a e f. Maybe (a -> Eff e Unit) -> PouchDB -> Eff (err :: EXCEPTION | f) Unit
foreign import destroy :: forall a b c d. Maybe (PouchDBOptions a) -> Maybe (b -> Eff c Unit) -> PouchDB -> Eff (err :: EXCEPTION | d) Unit
foreign import put     :: forall a b c d e. PouchDBDocument a -> Maybe String -> Maybe String -> Maybe (PouchDBOptions b) -> Maybe (c -> Eff d Unit) -> PouchDB -> Eff (err :: EXCEPTION | e) Unit

