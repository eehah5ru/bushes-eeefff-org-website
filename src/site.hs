{-# LANGUAGE OverloadedStrings #-}

import           Control.Monad ((>=>))
-- import           Data.ByteString.Lazy as BSL
import           Data.Default (def)
import Data.Maybe (fromMaybe)
-- import           Data.Monoid (mappend, (<>))
import           Hakyll
-- import           Hakyll.Core.Configuration (Configuration, previewPort)
-- import           Hakyll.Core.Metadata
import           Hakyll.Web.Sass (sassCompilerWith)
import Hakyll.Core.Compiler (getUnderlying)
import Hakyll.Web.Template.Internal (readTemplate)
import qualified Text.Sass.Options as SO

import Site.Types
import Site.SlimPage
import Site.MultiLang
--------------------------------------------------------------------------------

config :: Configuration
config = def { previewPort = 8001
             , previewHost = "0.0.0.0" }


main :: IO ()
main =
  hakyllWith config $
  do
     --
     -- images and static content
     --
     imagesRules
     fontsRules
     dataRules

     --
     -- CSS and SASS
     --
     cssAndSassRules

     --
     -- JS
     --
     jsRules

     --
     -- static pages
     --
     staticPagesRules

     -- archiveIndexPageRules

     -- archivePagesRules

     --
     -- projects and posts
     --
     -- postsRules
     -- projectsRules

     --
     -- collections
     --
     -- aggregatePagesRules

     --
     -- index page
     --
     -- indexPageRules
     -- indexEnPageRules

     --
     -- templates
     --

     templatesRules

--------------------------------------------------------------------------------

dataRules =
  match "data/**" $
        do route idRoute
           compile copyFileCompiler

imagesRules =
  match "images/**" $
  do route idRoute
     compile copyFileCompiler

fontsRules =
  match "fonts/*" $
        do route idRoute
           compile copyFileCompiler



sassOptions :: SO.SassOptions
sassOptions = def { SO.sassIncludePaths = Just [ "css/"
                                               , "bower_components/foundation-sites/scss/"] }

cssAndSassRules =
  do match "css/app.scss" $
       do scssDeps <- makePatternDependency "css/_*.scss"
          rulesExtraDependencies [scssDeps] $ do
            route $ setExtension "css"
            compile $ sassCompilerWith sassOptions >>= return . fmap compressCss

     match "css/**/*.css" $
       do route idRoute
          compile compressCssCompiler


jsRules =
  do match "js/*.js" $
           do route idRoute
              compile copyFileCompiler
     match "js/vendor/*.js" $
           do route idRoute
              compile copyFileCompiler


--
-- templates
--

ruPageTpl = "templates/page-ru.slim"
enPageTpl = "templates/page-en.slim"

rootTpl = "templates/default.slim"


staticPagesRules =
  do
    indexPage "index.slim"
    indexPage "map.slim"
    notFoundPage "404.slim"

  where
    indexPage = matchMultiLang ruRules enRules
    notFoundPage = matchMultiLang notFoundRuRules notFoundEnRules

    basicRules :: (Item String -> Compiler (Item String)) -> Rules ()
    basicRules f = slimPageRules $ \x -> return x
                                     >>= applyAsTemplate siteCtx
                                     >>= f


    ruRules = basicRules $ \x -> loadAndApplyTemplate ruPageTpl siteCtx x
                                 >>= loadAndApplyTemplate rootTpl siteCtx
                                 >>= relativizeUrls
    enRules = basicRules $ \x -> loadAndApplyTemplate enPageTpl siteCtx x
                                 >>= loadAndApplyTemplate rootTpl siteCtx
                                 >>= relativizeUrls

    notFoundRuRules = basicRules $ \x -> loadAndApplyTemplate ruPageTpl siteCtx x
                                         >>= loadAndApplyTemplate rootTpl siteCtx
    notFoundEnRules = basicRules $ \x -> loadAndApplyTemplate enPageTpl siteCtx x
                                         >>= loadAndApplyTemplate rootTpl siteCtx


templatesRules =
  do
    match "templates/*.html" $ compile templateCompiler
    match ("templates/*.slim" .&&. (complement "templates/_*.slim")) $ do
      slimDeps <- makePatternDependency "templates/_*.slim"
      rulesExtraDependencies [slimDeps] $ compile $
        getResourceString >>= withItemBody compileSlimWithEmptyLocals >>= withItemBody (return . readTemplate)


-- compilers

coffee :: Compiler (Item String)
coffee = getResourceString >>= withItemBody processCoffee
  where
    processCoffee = unixFilter "coffee" ["-c", "-s"] >=>
                    unixFilter "yuicompressor" ["--type", "js"]



--
--
-- contexts
--

siteCtx = ruUrlField `mappend`
          enUrlField `mappend`
          defaultContext
