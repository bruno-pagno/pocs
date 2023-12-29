import { BadGatewayException } from '@nestjs/common';
import Redis from 'ioredis';

export default class RedisClient {
  static async getRedisConnection(): Promise<Redis> {
    try {
      const redis = new Redis({
        lazyConnect: true,
        host: process.env.REDIS_HOST || 'localhost',
      });
      await redis.connect();
      return redis;
    } catch (error) {
      throw new BadGatewayException('Redis is not available');
    }
  }
}
