#pragma once

#if defined(_MSC_VER) && !defined(__clang__)
#ifdef GetObject
#undef GetObject
#endif
#endif

#include <rapidjson/document.h>
#include <rapidjson/error/en.h>

namespace mbgl {

using JSDocument = rapidjson::GenericDocument<rapidjson::UTF8<>, rapidjson::CrtAllocator>;
using JSValue = rapidjson::GenericValue<rapidjson::UTF8<>, rapidjson::CrtAllocator>;

std::string formatJSONParseError(const JSDocument&);

} // namespace mbgl
