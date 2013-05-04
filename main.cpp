/*
    Copyright (C) 2012 Dickson Leong
    This file is part of Tweetian.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

#include <QDeclarativeError>
#include <QDebug>
#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/qdeclarative.h>
#include <QtCore/QTranslator>
#include <QtCore/QLocale>
#include <QtCore/QFile>
#include <QtCore/QTextCodec>
#include <QtCore/QAbstractEventDispatcher>
#include <QtGui/QSplashScreen>
#include <QtGui/QPixmap>

#include "qmlapplicationviewer.h"
#include "src/socialinvocation.h"
#include "src/qmlutils.h"
#include "src/imageuploader.h"
#include "src/thumbnailcacher.h"
#include "src/userstream.h"
#include "src/networkmonitor.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    QTextCodec *codec = QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForTr(codec);

    QString lang = QLocale::system().name();
    lang.truncate(2); // ignore the country code

    const QStringList appArgs = app->arguments();
    foreach (const QString &arg, appArgs) {
        if (arg.startsWith(QLatin1String("--lang="))) {
            lang = arg.mid(7);
            break;
        }
    }

    QTranslator translator;
    if (QFile::exists("app/native/i18n/tweetian_" + lang + ".qm")) {
        qDebug("Translation for \"%s\" exists", qPrintable(lang));
        bool loaded = translator.load("tweetian_" + lang, "app/native/i18n");
        qDebug ("Language loaded: %s", (loaded == true)?"OK":"FAIL" );
    }
    else {
        qDebug("Translation for \"%s\" not exists, using the default language (en)", qPrintable(lang));
        translator.load("tweetian_en", "app/native/i18n");
    }
    app->installTranslator(&translator);

    app->setApplicationName("Tweetian");
    app->setOrganizationName("BB4 Software");
    app->setApplicationVersion(APP_VERSION);

    QSplashScreen *splash = new QSplashScreen(QPixmap("app/native/splash/tweetian-splash-symbian.jpg"));
    splash->show();
    splash->showMessage(QSplashScreen::tr("Loading..."), Qt::AlignHCenter | Qt::AlignBottom, Qt::white);

    QDeclarativeView view;
    QMLUtils qmlUtils(&view);
    ThumbnailCacher thumbnailCacher;
    NetworkMonitor networkMonitor;

    view.rootContext()->setContextProperty("SocialInvocation", new SocialInvocation());   
    view.rootContext()->setContextProperty("QMLUtils", &qmlUtils);
    view.rootContext()->setContextProperty("thumbnailCacher", &thumbnailCacher);
    view.rootContext()->setContextProperty("networkMonitor", &networkMonitor);
    view.rootContext()->setContextProperty("APP_VERSION", APP_VERSION);


    qmlRegisterType<ImageUploader>("Uploader", 1, 0, "ImageUploader");
    qmlRegisterType<UserStream>("UserStream", 1, 0, "UserStream");


    view.setSource(QUrl("app/native/qml/tweetian-symbian/main.qml"));

    view.showFullScreen();

    splash->finish(&view);
    splash->deleteLater();

    return app->exec();
}
