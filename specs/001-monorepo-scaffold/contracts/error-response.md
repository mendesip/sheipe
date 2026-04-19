# Contract: API Error Response Shape

All error responses from `Api::V1::BaseController` MUST conform to this shape.

## Schema

```json
{
  "error": {
    "code": "string",
    "message": "string",
    "details": "object | null"
  }
}
```

## Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `error.code` | string | Yes | Machine-readable error identifier (snake_case) |
| `error.message` | string | Yes | Human-readable description of the error |
| `error.details` | object \| null | No | Field-level errors for validation failures; null otherwise |

## Standard Codes

| HTTP Status | `error.code` | Trigger |
|---|---|---|
| 400 | `bad_request` | Missing required parameter |
| 403 | `forbidden` | `ActionPolicy::Unauthorized` |
| 404 | `not_found` | `ActiveRecord::RecordNotFound` |
| 422 | `validation_failed` | `ActiveRecord::RecordInvalid` |
| 500 | `internal_error` | Unhandled `StandardError` |

## Examples

**404 — Record not found**
```json
{
  "error": {
    "code": "not_found",
    "message": "Record not found",
    "details": null
  }
}
```

**422 — Validation failed**
```json
{
  "error": {
    "code": "validation_failed",
    "message": "Validation failed",
    "details": {
      "email": ["can't be blank", "is invalid"],
      "name": ["is too short (minimum is 2 characters)"]
    }
  }
}
```

**500 — Unhandled error (production)**
```json
{
  "error": {
    "code": "internal_error",
    "message": "Internal server error",
    "details": null
  }
}
```
