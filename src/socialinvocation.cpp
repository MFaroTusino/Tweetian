/*
    Copyright (C) 2013 Eduardo Zarate
    This file is part of Tweetian port to the BlackBerry 10 platform.

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

#include "socialinvocation.h"

#include <bb/system/InvokeRequest>

using namespace bb::system;

SocialInvocation::SocialInvocation(QObject *parent)
    : QObject(parent)
    , m_invokeManager(new InvokeManager(this))
{
}

void SocialInvocation::shareText(const QString &target, const QString &uri, const QString &data)
{
    // Create a new invocation request
    InvokeRequest request;

    if (target == QLatin1String("Facebook") || target == QLatin1String("facebook")) {
        request.setTarget("Facebook");
        request.setAction("bb.action.SHARE");
        request.setMimeType("text/plain");
        request.setUri("data://");
        request.setData(data.toUtf8());
    }

    if(target == QLatin1String("email")){
        request.setTarget("sys.pim.uib.email.hybridcomposer");
        request.setAction("bb.action.SHARE");
        request.setMimeType("text/plain");
        request.setData(data.toUtf8());
    }

    if(target == QLatin1String("bbm")){
        request.setTarget("sys.bbm.sharehandler");
        request.setAction("bb.action.SHARE");
        request.setMimeType("text/plain");
        request.setData(data.toUtf8());
    }

    m_invokeManager->invoke(request);
}

void SocialInvocation::showImage(const QString &file){

    QUrl url = QUrl::fromLocalFile ( file );

    InvokeRequest request;

    request.setTarget("sys.pictures.card.previewer");
    request.setAction("bb.action.VIEW");
    request.setMimeType("image/jpg");
    request.setUri( url.toString() );

    m_invokeManager->invoke(request);
}
